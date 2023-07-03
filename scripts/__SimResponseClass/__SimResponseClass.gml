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
	
	catchCallback = undefined;
	finallyCallback = undefined;
	
	#region jsDoc
	/// @func    While()
	/// @desc    Used to indicate whether it should rerun the callback or not, before the callback is executed.
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	#endregion
	static While = function(_callback) {
		whileCallback = _callback;
		return self;
	}
	
	#region jsDoc
	/// @func    Until()
	/// @desc    Used to indicate whether it should rerun the callback or not, after the callback is executed.
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	#endregion
	static Until = function(_callback) {
		untilCallback = _callback;
		return self;
	}
	
	#region jsDoc
	/// @func    Catch()
	/// @desc    Used to handle errors (if any).
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	#endregion
	static Catch = function(_callback) {
		catchCallback = _callback;
		return self;
	}
	
	#region jsDoc
	/// @func    Catch()
	/// @desc    Used to handle errors (if any).
	/// @self    __SimResponseClass
	/// @param   {Function} callback
	/// @returns {Struct.__SimResponseClass}
	#endregion
	static Finally = function(_callback) {
		finallyCallback = _callback;
		return self;
	}
}