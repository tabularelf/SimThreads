/// @func __SimThreadFuncExec( function/method, [arguments_in_array])
/// @desc Executes a runtime function, GML function or method, respecting method rules.
/// @param function/method
/// @param [arguments_in_array]
function __SimThreadFuncExec(_funcMethod, _args = []) {
	gml_pragma("forceinline");
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