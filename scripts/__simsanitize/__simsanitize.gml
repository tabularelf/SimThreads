function __SimSanitize(_entry, _args = undefined) {
	static _emptyArgs = [];
	if (_entry == undefined) return _entry;
	var _newEntry = _entry;
	var _mainArgs = _args ?? _emptyArgs;
	if ((!is_struct(_newEntry)) || is_method(_newEntry)) {
		_newEntry = SimCallback(_entry, _mainArgs);
	} else {
		if (!variable_instance_exists(_newEntry, "args")) {
			_newEntry.args = _mainArgs;
		}
	}
	return _newEntry;
}