function file_find_async(_filepath, _mask, _attr, _callback_per_file) {
	var _struct = new __file_find_class(_filepath, _mask, _attr, _callback_per_file);
	return _struct.__response;
}

function __file_find_class(_filepath, _mask, _attr, _callback_per_file) constructor {
	if (is_undefined(_callback_per_file)) {
		show_error("file_find_async: Argument _callback_per_file is undefined!", true);	
	}
	
	static __thread = new SimThread(10).SetMaxTime(0.5);
	
	__pos = 0;
	__file = undefined
	__filepath = _filepath;
	__mask = _mask;
	__attr = _attr;
	__callback_per_file = _callback_per_file;
	var _HandleFileCB = method(self, __HandleFile);
	
	// Fetch all file names, since these are synchronous anyway
	var _file = file_find_first(__mask, __attr);
	__files = [];
	while(_file != "") {
		array_push(__files, _file);
		_file = file_find_next();
	}
	file_find_close();
	
	// Store size
	__size = array_length(__files)-1;
	
	static __HandleFile = function() {
		__file = __files[__pos];
		if (__file != "") {
			__callback_per_file(__filepath, __file);
		}
		
		if (__file == "") {
			thread.Break();
			exit;
		}
		
		__pos++;
	}
	
	__response = __thread.Loop(array_length(__files), _HandleFileCB);
}