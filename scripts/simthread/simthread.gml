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
	__threadHead = 0;
	__pushNextPointer = 1;
	__inMainLoop = false;
	
	__currentTimer = time_source_create(time_source_game, 1, time_source_units_frames, function() { 
		var _totalTime = (get_timer() + game_get_speed(gamespeed_microseconds)) * __maxTimePercentage;
		__pushNextPointer = 1;
		__inMainLoop = true;
		if (__maxExecution == infinity) {
			repeat(ds_list_size(__threadQueue)) {
				__pushNextPointer = 1;
				var _exec = __threadQueue[| 0];
				__SimThreadFuncExec(_exec.callback, _exec.args);
				ds_list_delete(__threadQueue, 0);
				
				if (get_timer() > _totalTime) {
					if (SIMTHREAD_VERBOSE) __SimThreadTrace("Total time reached! Time taken: " + string(get_timer() - _totalTime) + "Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}	
		} else if (__maxExecution > 0) {
			repeat(__maxExecution) {
				if (ds_list_size(__threadQueue) == 0) break;
				__pushNextPointer = 1;
				var _exec = __threadQueue[| 0];
				__SimThreadFuncExec(_exec.callback, _exec.args);
				ds_list_delete(__threadQueue, 0);
				
				if (get_timer() > _totalTime) {
					if (SIMTHREAD_VERBOSE) __SimThreadTrace("Total time reached! Time taken: " + string(get_timer() - _totalTime) + "Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}		
		}
		// We reset this incase of sequential .PushNext calls
		__pushNextPointer = 1;
		__inMainLoop = false;
	}, [], -1);
	time_source_start(__currentTimer);
	
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
	
	static Insert = function(_pos, _entry) {
		var _newEntry = __SimSanitize(_entry);
		ds_list_insert(__threadQueue, clamp(_pos, 0, ds_list_size(__threadQueue)), _newEntry);	
		return self;		
	}

	static Push = function() {
		var _i = 0;
		repeat(argument_count) {
			var _entry = argument[_i];
			if (is_array(_entry)) {
				var _j = 0;
				repeat(array_length(_entry)) {
					ds_list_add(__threadQueue, __SimSanitize(_entry[_j++]));	
				}
			} else {
				ds_list_add(__threadQueue, __SimSanitize(_entry));		
			}
			++_i;
		}
		return self;
	}
	
	static PushNext = function() {
		if (!__inMainLoop) show_error(".PushNext cannot be used outside of the main push loop!", true);
		repeat(argument_count) {
			Insert(__pushNextPointer++, argument[0]);	
		}
		return self;
	}
	
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
		__pushNextPointer = 1;
		__inMainLoop = true;
		while(ds_list_size(__threadQueue) > 0) {
			__pushNextPointer = 1;
			var _exec = __threadQueue[| 0];
			__SimThreadFuncExec(_exec.callback, _exec.args);
			ds_list_delete(__threadQueue, 0);
		}
	}
	// Reset
	__pushNextPointer = 1;
	__inMainLoop = false;
}