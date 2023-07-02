function __SimResponseClass(_thread) constructor {
	thread = _thread;
	__forceBreak = false;
	__finished = false;
	__inLoop = false;
	__size = -1;
	__pos = 0;
	
	// Callbacks
	callback = undefined;
	whileCallback = undefined;
	untilCallback = undefined;
	
	tryCallback = undefined;
	catchCallback = undefined;
	finallyCallback = undefined;
	
	static While = function(_callback) {
		whileCallback = _callback;
		return self;
	}
	
	static Until = function(_callback) {
		untilCallback = _callback;
		return self;
	}
	
	static Catch = function(_callback) {
		catchCallback = _callback;
		return self;
	}
	
	static Finally = function(_callback) {
		finallyCallback = _callback;
		return self;
	}
}