function file_find_async(_filepath, _mask, _attr, _callback_per_file, _final_callback) {
	var _struct = new __file_find_class(_filepath, _mask, _attr, _callback_per_file, _final_callback);
}

function __file_find_class(_filepath, _mask, _attr, _callback_per_file, _final_callback = undefined) constructor {
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
	__HandleFileCB = method(self, __HandleFile);
	__finalCallback = _final_callback;
	
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
		if (__pos > __size) {
			if (!is_undefined(__finalCallback)) __finalCallback();
			exit;
		}
		__file = __files[__pos];
		if (__file != "") {
			__callback_per_file(__filepath, __file);
		}
		
		if (__file == "") {
			if (!is_undefined(__finalCallback)) __finalCallback();
			exit;
		}
		
		__pos++;
		__thread.PushNext(__HandleFileCB);
	}
	
	__thread.Push(__HandleFileCB);
}