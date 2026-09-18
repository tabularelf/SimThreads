/// @param {Struct.SimThread}
function __SimResponseClass(_thread, _frame) constructor {
	__thread = _thread;
	__forceBreak = false;
	__finished = false;
	__inLoop = false;
	__size = -1;
	__incrementor = 1;
	__pos = 0;
	__cancelled = false;
	__creationFrame = _frame;
	__maxFrameTime = infinity;
	__keepAlive = false;
	
	// Callbacks

	// @ignore
	callback = undefined;
	// @ignore
	whileCallback = undefined;
	// @ignore
	untilCallback = undefined;

	// @ignore
	finishCallback = [];
	// @ignore
	catchCallback = [];
	// @ignore
	finallyCallback = [];
	
	/// @desc    Used to indicate whether it should rerun the callback or not, before the callback is executed.
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static While = function(_callback) {
		whileCallback = _callback;
		untilCallback = undefined;
		return self;
	}

	/// @return {Struct.SimThread}
	static GetThread = function() {
		return __thread;
	};
	
	/// @desc    Used to indicate whether it should rerun the callback or not, after the callback is executed.
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static Until = function(_callback) {
		untilCallback = _callback;
		whileCallback = undefined;
		return self;
	}

	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static OnFinish = function(_callback) {
		array_push(finishCallback, _callback);
		return self;
	};
	
	/// @desc    Used to handle errors (if any).
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static OnCatch = function(_callback) {
		array_push(catchCallback, _callback);
		return self;
	}
	
	/// @desc    Used to handle errors (if any).
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	static OnFinally = function(_callback) {
		array_push(finallyCallback, _callback);
		return self;
	}
	
	static Cancel = function() {
		__cancelled = true;
		__forceBreak = true;
		return self;
	}
	
	static SetMaxFrameTime = function(_value) { 
		__maxFrameTime = _value;
		return self;
	}
	
	static GetMaxFrameTime = function() {
		return __maxFrameTime;	
	}
	
	static KeepAlive = function(_value) {
		__keepAlive = _value;
		return self;
	}

	static IsFinished = function() {
		return __finished;
	};

	static IsCancelled = function() {
		return __cancelled;	
	}
	
	/// @deprecated
	static Finished = method(undefined, IsFinished);
	
	/// @deprecated
	static Cancelled = method(undefined, IsCancelled);

	/// @deprecated
	static Catch = method(undefined, OnCatch);

	/// @deprecated
	static Finally = method(undefined, OnFinally);
}
