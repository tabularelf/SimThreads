/// @func SimThread([maxExecution])
/// @param [maxExecution]
/// @feather ignore all
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
	__pos = 0;
	
	__currentTimer = time_source_create(time_source_global, 1, time_source_units_frames, method(self, __update), [], -1);
	time_source_start(__currentTimer);
	
	/// @desc    Forces the Simthread to stop whatever code is being executed during the response (in the case of a loop).
	///          Note: This only interrupts the loop, but not the current callback that's still processing. You will need to call return; or exit; to exit out of the callback.
	/// @self    SimThread
	/// @param   {Bool} forceCallback
	/// @returns {undefined}
	static Break = function(_forceCallback = false) {
		if (!__inMainLoop) show_error(".Break() cannot be used outside of the main SimThread loop!", true);
		
		__currentStruct.__forceBreak = true;
	}
	
	static __update = function() { 
		var _prevTime = get_timer();
		var _totalTime = (_prevTime + (game_get_speed(gamespeed_microseconds) *  __maxTimePercentage));
		__pushNextPointer = 1;
		__inMainLoop = true;
		if (__maxExecution == infinity) {
			while(__size > 0) {
				if (__size == 0) break;
				__pos = __pos % __size;
				__pushNextPointer = 1;
				var _exec = __threadQueue[| __pos];
				__currentStruct = _exec;
				var _result = __SimHandleResponse(_exec);
				__currentStruct = undefined;
				if (_result) {
					ds_list_delete(__threadQueue, __pos);	
					--__pos;
					--__size;
				}
				++__pos;
				
				if (get_timer() > _totalTime) {
					if (SIMTHREAD_VERBOSE) __SimThreadTrace("Total time reached! Time taken: " + string((get_timer() - _prevTime) / 1000) + " Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}	
		} else if (__maxExecution > 0) {
			repeat(__maxExecution) {
				if (__size == 0) break;
				__pos = __pos % __size;
				__pushNextPointer = 1;
				var _exec = __threadQueue[| __pos];
				__currentStruct = _exec;
				var _result = __SimHandleResponse(_exec);
				__currentStruct = undefined;
				if (_result) {
					ds_list_delete(__threadQueue, __pos);	
					--__pos;
					--__size;
				}
				++__pos;
				
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
	
	/// @desc    Pauses the SimThread execution.
	/// @self    SimThread
	/// @returns {Struct.SimThread}
	static Pause = function() {
		if (SIMTHREAD_VERBOSE) __SimThreadTrace("Paused!");
		if (time_source_exists(__currentTimer)) {
			time_source_stop(__currentTimer);	
		}
		return self;
	}
	
	/// @desc    Unpauses the SimThread execution.
	/// @self    SimThread
	/// @returns {Struct.SimThread}
	static Resume = function() {
		if (SIMTHREAD_VERBOSE) __SimThreadTrace("Resumed!");
		if (time_source_exists(__currentTimer)) {
			time_source_start(__currentTimer);
		}
		return self;
	}
	
	/// @desc    Sets the max time a given SimThread can execute (with percent being a value between 0 to 1) per step.
	/// @self    SimThread
	/// @param   {Bool} percent : A float between 0-1.
	/// @returns {Struct.SimThread}
	static SetMaxTime = function(_percentage) {
		__maxTimePercentage = _percentage;
		return self;
	}
	
	/// @desc    Sets the max time a given SimThread can execute (with percent being a value between 0 to 1) per step.
	/// @self    SimThread
	/// @param   {Real} number
	/// @returns {Struct.SimThread}
	static SetMaxExecution = function(_num) {
		__maxExecution = _num;
		return self;
	}
	
	/// @desc    Inserts a function/method or struct to a set position within the SimThread.
	/// @self    SimThread
	/// @param   {Real} pos
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static Insert = function(_pos, _callback) {
		if (time_source_get_state(time_source_state_stopped)) time_source_start(__currentTimer);
		var _response = new __SimResponseClass(self);
		_response.callback = __SimSanitize(_callback);
		//var _newEntry = __SimSanitize(_entry);
		ds_list_insert(__threadQueue, clamp(_pos, 0, __size), _response);	
		++__size;
		return _response;		
	}

	/// @desc    Pushes one or multiple functions/methods or structs, adding at the end of the queue.
	/// @self    SimThread
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static Push = function(_callback) {
		if (time_source_get_state(time_source_state_stopped)) time_source_start(__currentTimer);
		var _response = new __SimResponseClass(self);
		_response.callback = __SimSanitize(_callback);
		ds_list_add(__threadQueue, _response);
		++__size;
		return _response;
	}
	
	/// @desc    Pushes the next callback immediately behind this one.
	/// @self    SimThread
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static PushNext = function(_callback) {
		if (!__inMainLoop) show_error(".PushNext cannot be used outside of the main SimThread loop!", true);
		return Insert(__pushNextPointer++, _callback);
	}
	
	/// @desc    Clears the SimThread queue.
	/// @self    SimThread
	/// @returns {Struct.SimThread}
	static Clear = function() {
		ds_list_clear(__threadQueue);
		return self;
	}
	
	/// @desc    Frees the SimThread queue.
	/// @self    SimThread
	/// @returns {undefined}
	static Destroy = function() {
		time_source_destroy(__currentTimer);	
		ds_list_destroy(__threadQueue);
		__threadQueue = undefined;
	}
	
	/// @desc    Gets the length of the SimThread queue.
	/// @self    SimThread
	/// @returns {Real}
	static GetQueueLength = function() {
		return ds_list_size(__threadQueue);	
	}
	
	/// @desc    Flushes all functions (aka executes all functions/methods) within the queue, regardless of the settings of .SetMaxTime() and .SetMaxExecutions(), and regardless if it's paused or not.
	/// @self    SimThread
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
	
	/// @desc    Begins looping a callback until X size is reached. This hooks onto the .While() method of __SimResponseClass.
	/// @self    SimThread
	/// @param   {Real} size
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
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