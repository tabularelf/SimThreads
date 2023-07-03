/// @func SimThread([maxExecution])
/// @param [maxExecution]
/// @feather ignore GM1042
/// @feather ignore GM1043
function SimThread(_maxExecution = infinity) constructor {
	static __id = -1;
	self.__id = ++__id;
	__maxTimePercentage = 1;
	__maxExecution = _maxExecution;
	__threadQueue = ds_list_create();
	__pushNextPointer = 1;
	__inMainLoop = false;
	__currentStruct = undefined;
	__size = 0;
	
	__currentTimer = time_source_create(time_source_global, 1, time_source_units_frames, method(self, __update), [], -1);
	time_source_start(__currentTimer);
	
	static Break = function(_forceCallback = false) {
		if (__currentStruct == undefined) return;
		
		__currentStruct.__forceBreak = true;
	}
	
	static __update = function() { 
		static _pos = 0;
		var _prevTime = get_timer();
		var _totalTime = (_prevTime + (game_get_speed(gamespeed_microseconds) *  __maxTimePercentage));
		__pushNextPointer = 1;
		__inMainLoop = true;
		if (__maxExecution == infinity) {
			while(__size > 0) {
				if (__size == 0) break;
				_pos = _pos % __size;
				__pushNextPointer = 1;
				var _exec = __threadQueue[| _pos];
				__currentStruct = _exec;
				var _result = __SimHandleResponse(_exec);
				__currentStruct = undefined;
				if (_result) {
					ds_list_delete(__threadQueue, _pos);	
					--_pos;
					--__size;
				}
				++_pos;
				
				if (get_timer() > _totalTime) {
					if (SIMTHREAD_VERBOSE) __SimThreadTrace("Total time reached! Time taken: " + string((get_timer() - _prevTime) / 1000) + " Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}	
		} else if (__maxExecution > 0) {
			repeat(__maxExecution) {
				if (__size == 0) break;
				_pos = _pos % __size;
				__pushNextPointer = 1;
				var _exec = __threadQueue[| _pos];
				var _result = __SimHandleResponse(_exec);
				if (_result) {
					ds_list_delete(__threadQueue, _pos);	
					--_pos;
					--__size;
				}
				
				if (get_timer() > _totalTime) {
					if (SIMTHREAD_VERBOSE) __SimThreadTrace("Total time reached! Time taken: " + string((get_timer() - _prevTime) / 1000) + " Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}
			
			if (GetQueueLength() > 0) {
				if (SIMTHREAD_VERBOSE) __SimThreadTrace("Max executions reached! Saving for next frame...");	
			}
		}
		// We reset this incase of sequential .PushNext calls
		__pushNextPointer = 1;
		__inMainLoop = false;
		
		// Turn off SimThread process when not in use
		if (ds_list_size(__threadQueue) < 1) {
			time_source_stop(__currentTimer);	
		}
	}
	
	static Pause = function() {
		if (SIMTHREAD_VERBOSE) __SimThreadTrace("Paused!");
		if (time_source_exists(__currentTimer)) {
			time_source_stop(__currentTimer);	
		}
		return self;
	}
	
	static Resume = function() {
		if (SIMTHREAD_VERBOSE) __SimThreadTrace("Resumed!");
		if (time_source_exists(__currentTimer)) {
			time_source_start(__currentTimer);
		}
		return self;
	}
	
	static SetMaxTime = function(_percentage) {
		__maxTimePercentage = _percentage;
		return self;
	}
	
	static SetMaxExecution = function(_num) {
		__maxExecution = _num;
		return self;
	}
	
	static Insert = function(_pos, _callback) {
		if (time_source_get_state(time_source_state_stopped)) time_source_start(__currentTimer);
		var _response = new __SimResponseClass(self);
		_response.callback = __SimSanitize(_callback);
		//var _newEntry = __SimSanitize(_entry);
		ds_list_insert(__threadQueue, clamp(_pos, 0, __size), _response);	
		++__size;
		return _response;		
	}

	static Push = function(_callback) {
		if (time_source_get_state(time_source_state_stopped)) time_source_start(__currentTimer);
		var _response = new __SimResponseClass(self);
		_response.callback = __SimSanitize(_callback);
		ds_list_add(__threadQueue, _response);
		++__size;
		//var _i = 0;
		//repeat(argument_count) {
		//	var _entry = argument[_i];
		//	if (is_array(_entry)) {
		//		var _j = 0;
		//		repeat(array_length(_entry)) {
		//			ds_list_add(__threadQueue, __SimSanitize(_entry[_j++]));	
		//		}
		//	} else {
		//		ds_list_add(__threadQueue, __SimSanitize(_entry));		
		//	}
		//	++_i;
		//}
		return _response;
	}
		
	static PushNext = function(_callback) {
		if (!__inMainLoop) show_error(".PushNext cannot be used outside of the main push loop!", true);
		return Insert(__pushNextPointer++, _callback);
	}
		
	static Do = Push;
	
	static Clear = function() {
		ds_list_clear(__threadQueue);
		return self;
	}
	
	static Destroy = function() {
		time_source_destroy(__currentTimer);	
		ds_list_destroy(__threadQueue);
		__threadQueue = undefined;
	}
	
	static GetQueueLength = function() {
		return ds_list_size(__threadQueue);	
	}
	
	static Flush = function() {
		static _pos = 0;
		__pushNextPointer = 1;
		__inMainLoop = true;
		while(__size > 0) {
				_pos = _pos % __size;
				__pushNextPointer = 1;
				var _exec = __threadQueue[| 0];
				__currentStruct = _exec;
				var _result = __SimHandleResponse(_exec);
				__currentStruct = undefined;
				if (_result) {
					ds_list_delete(__threadQueue, 0);	
					--__size;
					--_pos;
				}
		}
		// Reset
		__pushNextPointer = 1;
		__inMainLoop = false;
	}
	
	static Loop = function(_size, _callback) {
		if (time_source_get_state(time_source_state_stopped)) time_source_start(__currentTimer);
		var _response = new __SimResponseClass(self);
		_response.callback = __SimSanitize(_callback);
		_response.whileCallback = method(_response, function(_pos) {
			return _pos	<= __size;
		});
		_response.__size = int64(_size-1);
		_response.__pos = int64(0);
		_response.__inLoop = true;
		ds_list_add(__threadQueue, _response);
		++__size;
		return _response;
	}
}