/// @ignore
/// @feather ignore all
function __SimThreadFuncExec(_funcMethod, _args = undefined) {
	gml_pragma("forceinline");
	
	if (_args == undefined) return _funcMethod();
	
	var _func = _funcMethod;
	var _self = self;
	
	if (is_method(_func)) {
		_self = method_get_self(_func) ?? self;
		_func = method_get_index(_func);
	}
	
	with(_self) {
		return script_execute_ext(_func, _args);
	}
}