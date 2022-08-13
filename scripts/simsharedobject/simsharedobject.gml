function SimSharedObject(_self = self, _callback = undefined) constructor {
	__SimSelfRef = _self;
	if (is_method(_callback)) {
		__Callback = method_get_index(_callback);
	} else {
		__Callback = _callback;	
	}
	
	static __FINISH = function() {
		if (!is_undefined(__Callback)) {
			var _callback = __Callback;
			with(__SimSelfRef) {
				_callback();
			}
		}
		
		__SimSelfRef = undefined;
	}
	
	static End = function() {
		return Bind(__FINISH);	
	}
	
	static Bind = function(_func) {
		return method(self, _func);	
	}
}