/// @func SimThread([maxExecution])
/// @param [maxExecution]
/// @feather ignore all
function SimThread(_maxExecution = infinity) constructor {
	static __id = -1;
	__frame = 0;
	self.__id = ++__id;
	__maxTimePercentage = 1;
	__maxExecution = _maxExecution;
	__threadQueue = [];
	__pushNextPointer = 1;
	__inMainLoop = false;
	__currentStruct = undefined;
	__size = 0;
	__pos = 0;
	__autoStep = true;
	__lastTime = current_time;
	__deltaTime = 0;
	__iterationCallback = undefined;
	
	__currentTimer = time_source_create(time_source_global, 1, time_source_units_frames, method(self, __Update), [], -1);
	//time_source_start(__currentTimer);
	
	#region Public Methods
	static AutoStep = function(_bool) {
		if (_bool) {
			time_source_start(__currentTimer);
			__autoStep = true;
		} else {
			time_source_stop(__currentTimer);
			__autoStep = false;
		}
		return self;
	}
	
	static Step = function() {
		__Update();	
	}
	
	/// @desc    Forces the Simthread to stop whatever code is being executed during the response (in the case of a loop).
	///          Note: This only interrupts the loop, but not the current callback that's still processing. You will need to call return; or exit; to exit out of the callback.
	/// @self    SimThread
	/// @param   {Bool} forceCallback
	/// @returns {undefined}
	static Break = function(_forceCallback = false) {
		if (!__inMainLoop) show_error(".Break() cannot be used outside of the main SimThread loop!", true);
		
		__currentStruct.__forceBreak = true;
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
	/// @returns {Struct.__SimTaskClass}
	static Insert = function(_pos, _callback, _args = undefined) {
		var _tsState = time_source_get_state(__currentTimer);
		if (_tsState == time_source_state_stopped || _tsState == time_source_state_initial) && (__autoStep) time_source_start(__currentTimer);
		var _response = new __SimTaskClass(self, __frame);
		_response.callback = __SimSanitize(_callback, _args, other);
		//var _newEntry = __SimSanitize(_entry);
		array_insert(__threadQueue, clamp(_pos, 0, __size), _response);	
		++__size;
		return _response;		
	}

	/// @desc    Pushes one or multiple functions/methods or structs, adding at the end of the queue.
	/// @self    SimThread
	/// @param   {Function} callback
	/// @returns {Struct.__SimTaskClass}
	static Push = function(_callback, _args = undefined) {
		var _tsState = time_source_get_state(__currentTimer);
		if (_tsState == time_source_state_stopped || _tsState == time_source_state_initial) && (__autoStep) time_source_start(__currentTimer);
		var _response = new __SimTaskClass(self, __frame);
		_response.callback = __SimSanitize(_callback, _args, other);
		array_push(__threadQueue, _response);
		++__size;
		return _response;
	}
	
	/// @desc    Pushes the next callback immediately behind this one.
	/// @self    SimThread
	/// @param   {Function} callback
	/// @returns {Struct.__SimTaskClass}
	static PushNext = function(_callback) {
		if (!__inMainLoop) show_error(".PushNext cannot be used outside of the main SimThread loop!", true);
		return Insert(__pushNextPointer++, _callback);
	}
	
	/// @desc    Clears the SimThread queue.
	/// @self    SimThread
	/// @returns {Struct.SimThread}
	static Clear = function() {
		array_resize(__threadQueue, 0);
		return self;
	}
	
	/// @desc    Frees the SimThread queue.
	/// @self    SimThread
	/// @returns {undefined}
	static Destroy = function() {
		time_source_destroy(__currentTimer);	
		delete __threadQueue;
		__size = 0;
		__pos = 0;
	}
	
	/// @desc    Gets the length of the SimThread queue.
	/// @self    SimThread
	/// @returns {Real}
	static GetQueueLength = function() {
		return array_length(__threadQueue);	
	}
	
	/// @desc    Flushes all functions (aka executes all functions/methods) within the queue, regardless of the settings of .SetMaxTime() and .SetMaxExecutions(), and regardless if it's paused or not.
	/// @self    SimThread
	static Flush = function() {
		var _pos = 0;
		__pushNextPointer = 1;
		__inMainLoop = true;
		while(__size > 0) {
				_pos = _pos % __size;
				__pushNextPointer = _pos+1;
				var _exec = __threadQueue[_pos];
				__currentStruct = _exec;
				var _result = __SimHandleResponse(_exec);
				__currentStruct = undefined;
				if (_result) {
					array_delete(__threadQueue, _pos, 1);	
					--__size;
					--_pos;
				}
				_pos++;
		}
		// Reset
		array_resize(__threadQueue, 0);
		__pushNextPointer = 1;
		__inMainLoop = false;
		return self;
	}
	
	/// @desc    Begins looping a callback until X size is reached. This hooks onto the .While() method of __SimTaskClass.
	/// @self    SimThread
	/// @param   {Real} size
	/// @param   {Function} callback
	/// @returns {Struct.__SimTaskClass}
	static Loop = function(_size, _callback, _args = undefined) {
		var _tsState = time_source_get_state(__currentTimer);
		if (_tsState == time_source_state_stopped || _tsState == time_source_state_initial) && (__autoStep) time_source_start(__currentTimer);
		var _response = new __SimTaskClass(self, __frame);
		_response.callback = __SimSanitize(_callback, _args, other);
		_response.whileCallback = method(_response, function(_pos) {
			return _pos	<= __size;
		});
		_response.__size = int64(_size-1);
		_response.__pos = int64(0);
		_response.__inLoop = true;
		array_push(__threadQueue, _response);
		++__size;
		return _response;
	}

	/// @desc    Begins looping a callback until X size is reached. This hooks onto the .While() method of __SimTaskClass.
	/// @self    SimThread
	/// @param   {Real} size
	/// @param   {Function} callback
	/// @returns {Struct.__SimTaskClass}
	static InvertedLoop = function(_size, _callback, _args = undefined) {
		var _tsState = time_source_get_state(__currentTimer);
		if (_tsState == time_source_state_stopped || _tsState == time_source_state_initial) && (__autoStep) time_source_start(__currentTimer);
		var _response = new __SimTaskClass(self, __frame);
		_response.callback = __SimSanitize(_callback, _args, other);
		_response.whileCallback = method(_response, function(_pos) {
			return _pos >= 0;
		});
		_response.__pos = int64(_size-1);
		_response.__inLoop = true;
		_response.__incrementor = -1;
		array_push(__threadQueue, _response);
		++__size;
		return _response;
	}
	
	static GetDeltaTime = function() {
		return __deltaTime;	
	}

	/// @self    __SimTaskClass
	/// @param {Function} callback
	static SetIterationCallback = function(_callback) {
		__iterationCallback = _callback;
		return self;
	};
	#endregion
	
	#region Private Methods
	static __Execute = function() {
		__pos = __pos % __size;
		__pushNextPointer = __pos+1;
		var _exec = __threadQueue[__pos];
		__currentStruct = _exec;
		var _result = __SimHandleResponse(_exec);
		__currentStruct = undefined;
		
		if (_result) && (!_exec.__keepAlive) {
			if (is_array(__threadQueue)) array_delete(__threadQueue, __pos, 1);	
			--__pos;
			--__size;
		}
		++__pos;	
	};
	
	static __Update = function() { 
		// Update frame counter
		++__frame;
		var _prevTime = get_timer();
		var _totalTime = (_prevTime + (game_get_speed(gamespeed_microseconds) *  __maxTimePercentage));
		__pushNextPointer = 1;
		__inMainLoop = true;
		if (__maxExecution == infinity) {
			while(__size > 0) {
				__deltaTime = current_time - __lastTime;
				if (__size == 0) break;
				__Execute();
				
				if (get_timer() > _totalTime) {
					if (SIMTHREAD_VERBOSE) __SimThreadTrace("Total time reached! Time taken: " + string((get_timer() - _prevTime) / 1000) + " Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}	
		} else if (__maxExecution > 0) {
			repeat(__maxExecution) {
				__deltaTime = current_time - __lastTime;
				if (__size == 0) break;
				__Execute();
				
				if (get_timer() > _totalTime) {
					if (SIMTHREAD_VERBOSE) __SimThreadTrace("Total time reached! Time taken: " + string((get_timer() - _prevTime) / 1000) + " Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}
			__lastTime = current_time;
			if (GetQueueLength() > 0) {
				if (SIMTHREAD_VERBOSE) __SimThreadTrace("Max executions reached! Saving for next frame...");	
			}
		}
		// We reset this incase of sequential .PushNext calls
		__pushNextPointer = 1;
		__inMainLoop = false;
		if (is_callable(__iterationCallback)) __iterationCallback();
		
		// Turn off SimThread process when not in use
		if (is_array(__threadQueue)) && (array_length(__threadQueue) < 1) {
			time_source_stop(__currentTimer);	
		}
	}
	#endregion
}