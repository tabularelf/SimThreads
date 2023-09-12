function __SimResponseClass(_thread) constructor {
	thread = _thread;
	__forceBreak = false;
	__finished = false;
	__inLoop = false;
	__size = -1;
	__pos = 0;
	__delayNum = 0;
	__cancelled = false;
	
	// Callbacks
	callback = undefined;
	whileCallback = undefined;
	untilCallback = undefined;
	
	catchCallback = [];
	finallyCallback = [];
	
	/// @desc    Used to indicate whether it should rerun the callback or not, before the callback is executed.
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static While = function(_callback) {
		whileCallback = _callback;
		return self;
	}
	
	/// @desc    Used to indicate whether it should rerun the callback or not, after the callback is executed.
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static Until = function(_callback) {
		untilCallback = _callback;
		return self;
	}
	
	/// @desc    Used to handle errors (if any).
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static Catch = function(_callback) {
		array_push(catchCallback, _callback);
		return self;
	}
	
	/// @desc    Used to handle errors (if any).
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static Finally = function(_callback) {
		array_push(finallyCallback, _callback);
		return self;
	}
	
	static Delay = function(_num) {
		__delayNum = _num;	
		return self;
	}
	
	static DelayAdd = function(_num) {
		__delayNum += _num;	
		return self;
	}
	
	static Cancel = function() {
		__cancelled = true;
	}
}