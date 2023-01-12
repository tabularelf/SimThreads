function __SimSanitize(_entry, _args = []) {
	var _newEntry = _entry;
	if ((!is_struct(_newEntry)) || is_method(_newEntry)) {
		_newEntry = SimCallback(_entry, _args);
	} else {
		if (!variable_instance_exists(_newEntry, "args")) {
			_newEntry.args = _args;
		}
	}
	return _newEntry;
}