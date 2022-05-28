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
	
	__currentTimer = time_source_create(time_source_game, 1, time_source_units_frames, function() { 
		var _totalTime = (get_timer()/1000) + (1000/game_get_speed(gamespeed_fps)) * __maxTimePercentage;
		if (__maxExecution == infinity) {
			repeat(ds_list_size(__threadQueue)) {
				var _exec = __threadQueue[| 0];
				function_execute(_exec.callback, _exec.args);
				ds_list_delete(__threadQueue, 0);
				
				if ((get_timer()/1000) > _totalTime) {
					if (SIMTHREAD_VERBOSE) __simthreadtrace("Total time reached! Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}	
		} else if (__maxExecution > 0) {
			repeat(__maxExecution) {
				if (ds_list_size(__threadQueue) == 0) break;
				
				var _exec = __threadQueue[| 0];
				function_execute(_exec.callback, _exec.args);
				ds_list_delete(__threadQueue, 0);
				
				if ((get_timer()/1000) > _totalTime) {
					if (SIMTHREAD_VERBOSE) __simthreadtrace("Total time reached! Remaining queued: " + string(GetQueueLength()));
					break;
				}
			}		
		}
	}, [], -1);
	time_source_start(__currentTimer);
	
	static Pause = function() {
		if (SIMTHREAD_VERBOSE) __simthreadtrace("Paused!");
		if (time_source_exists(__currentTimer)) {
			time_source_stop(__currentTimer);	
		}
		return self;
	}
	
	static Resume = function() {
		if (SIMTHREAD_VERBOSE) __simthreadtrace("Resumed!");
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
	
	static Insert = function(_entry, _pos) {
		var _newEntry = _entry;
		if ((!is_struct(_newEntry)) || is_method(_newEntry))  {
			_newEntry = {
				callback: _entry,
				args: []
			}	
		}
		
		if (_pos == -1) {
			ds_list_add(__threadQueue, _newEntry);	
		} else {
			ds_list_insert(__threadQueue, max(_pos, 0), _newEntry);	
		}
		return self;		
	}
	
	
	static Push = function() {
		var _i = 0;
		repeat(argument_count) {
			var _entry = argument[_i];
			if (is_array(_entry)) {
				var _j = 0;
				repeat(array_length(_entry)) {
					var _newEntry = _entry[_j++];
					if ((!is_struct(_newEntry)) || is_method(_newEntry)) {
						_newEntry = {
							callback: _entry,
							args: []
						}
					}
					ds_list_add(__threadQueue, _newEntry);	
				}
			} else {
				var _newEntry = _entry;
				if ((!is_struct(_newEntry)) || is_method(_newEntry)) {
					_newEntry = {
						callback: _entry,
						args: []
					}
				}
				ds_list_add(__threadQueue, _newEntry);		
			}
			++_i;
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
		var _i = 0;
		repeat(ds_list_size(__threadQueue)) {
			var _exec = __threadQueue[| _i++];
			function_execute(_exec.callback, _exec.args);
		}
		ds_list_clear(__threadQueue);
	}
}