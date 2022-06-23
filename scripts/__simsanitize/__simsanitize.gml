function __SimSanitize(_entry) {
	var _newEntry = _entry;
	if ((!is_struct(_newEntry)) || is_method(_newEntry)) {
		_newEntry = {
			callback: _entry,
			args: [],
			fixedStep: false
		}
	} else {
		if (!variable_instance_exists(_newEntry, "args")) {
			_newEntry.args = [];
		}
		
		if (!variable_instance_exists(_newEntry, "fixedStep")) {
			_newEntry.fixedStep = false;
		}
	}
	return _newEntry;
}