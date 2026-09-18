/// @ignore
/// @feather ignore all
function __SimSanitize(_entry, _args = undefined, _scope = undefined) {
	if (is_undefined(_entry)) return _entry;
	var _newEntry = _entry;
	if (!is_method(_newEntry)) _newEntry = method(_scope, _newEntry);
	return {
		ptr: _newEntry,
		args: _args,
	};
}