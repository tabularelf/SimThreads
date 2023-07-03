function __SimSanitize(_entry, _args = undefined) {
	if (_entry == undefined) return _entry;
	var _newEntry = _entry;
	if ((!is_struct(_newEntry)) || is_method(_newEntry)) {
		_newEntry = SimCallback(_entry, _args);
	} else {
		if (!variable_instance_exists(_newEntry, "args")) {
			_newEntry.args = _mainArgs;
		}
	}
	return _newEntry;
}



//-------------------------------------------------------------------------------------------------------\\
//     __     You seem like you're looking for useful functions
//    /  \  /   Would you like help with that?
//    |  |
//    @  @    You can try checking out the public scripts
//    |  |    - SimCallback
//    || |/   - SimCallback
//    || ||   - SimTick
//    |\_/|   
//    \___/   
//
//-------------------------------------------------------------------------------------------------------//