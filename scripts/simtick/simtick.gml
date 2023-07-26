/// @func SimTick([maxExecution])
/// @param [maxTicks]
/// @feather ignore GM1042
/// @feather ignore GM1043
function SimTick(_ticks = game_get_speed(gamespeed_fps)) constructor {
	static __id = -1;
	self.__id = ++__id;
	__maxTicks = _ticks;
	__currentTick = 0;
	__lastPlacedTick = 0;
	__ticksQueue = array_create(_ticks);
	var _i = 0;
	repeat(array_length(__ticksQueue)) {
		__ticksQueue[_i++] = [];
	}
	
	__currentTimer = time_source_create(time_source_global, 1, time_source_units_frames, function() { 
		var _i = 0;
		var _currentTickQueue = __ticksQueue[__currentTick];
		repeat(array_length(_currentTickQueue)) {
			var _exec = _currentTickQueue[_i];
			__SimThreadFuncExec(_exec.callback, _exec.args);
			++_i;
		}
		__currentTick = (__currentTick + 1) % __maxTicks;
	}, [], -1);
	time_source_start(__currentTimer);
	
	/// @desc    Pauses the SimTick
	/// @self    SimTick
	/// @returns {Struct.SimTick}
	static Pause = function() {
		if (SIMTHREAD_VERBOSE) __SimThreadTrace("Paused!");
		if (time_source_exists(__currentTimer)) {
			time_source_stop(__currentTimer);	
		}
		return self;
	}
	
	/// @desc    Unpauses the SimTick
	/// @self    SimTick
	/// @returns {Struct.SimTick}
	static Resume = function() {
		if (SIMTHREAD_VERBOSE) __SimThreadTrace("Resumed!");
		if (time_source_exists(__currentTimer)) {
			time_source_start(__currentTimer);
		}
		return self;
	}
	
	/// @desc    Unpauses the SimTick
	/// @self    SimTick
	/// @param   {Real} pos
	/// @param   {Function} callback
	/// @returns {Struct.SimTick}
	static Insert = function(_pos = undefined, _entry) {
		var _newEntry = __SimSanitize(_entry);
		
		if (is_undefined(_pos)) {
			array_push(__ticksQueue[__lastPlacedTick], _newEntry);	
			__lastPlacedTick = (__lastPlacedTick + 1) % __maxTicks;
		} else {
			array_push(__ticksQueue[clamp(_pos, 0, __maxTicks-1)], _newEntry);	
		}
		return self;		
	}
	
	/// @desc    Unpauses the SimTick
	/// @self    SimTick
	/// @param   {Function} callback
	/// @returns {Struct.SimTick}
	static Push = function() {
		var _i = 0;
		repeat(argument_count) {
			var _entry = argument[_i];
			if (is_array(_entry)) {
				var _j = 0;
				repeat(array_length(_entry)) {
					array_push(__ticksQueue[__lastPlacedTick], __SimSanitize(_entry[_j++]));	
					__lastPlacedTick = (__lastPlacedTick + 1) % __maxTicks;
				}
			} else {
				array_push(__ticksQueue[__lastPlacedTick], __SimSanitize(_entry));	
				__lastPlacedTick = (__lastPlacedTick + 1) % __maxTicks;
			}
			++_i;
		}
		return self;
	}
	
	/// @desc    Clears the SimTick
	/// @self    SimTick
	/// @param   {Real} pos
	/// @returns {Struct.SimTick}
	static Clear = function(_pos = undefined) {
		if (is_undefined(_pos)) {
			var _i = 0;
			repeat(array_length(__ticksQueue)) {
				array_resize(__ticksQueue[_i++], 0);	
			}
		} else {
			array_resize(__ticksQueue[_pos], 0);	
		}
		return self;
	}
	
	/// @desc    Get's the maximum number of ticks.
	/// @self    SimTick
	/// @returns {Real}
	static GetMaxTicks = function() {
		return __maxTicks;	
	}
	
	/// @desc    Destroys the SimTick
	/// @self    SimTick
	static Destroy = function() {
		time_source_destroy(__currentTimer);	
		__ticksQueue = undefined;
	}
}