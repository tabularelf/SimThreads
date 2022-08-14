function file_find_async(_filepath, _mask, _attr, _callback_per_file) {
	var _struct = new __file_find_class(_filepath, _mask, _attr, _callback_per_file);
}

function __file_find_class(_filepath, _mask, _attr, _callback_per_file) constructor {
	if (is_undefined(_callback_per_file)) {
		show_error("file_find_async: Argument _callback_per_file is undefined!", true);	
	}
	
	static __thread = new SimThread(10).SetMaxTime(0.5);
	
	__file = undefined
	__filepath = _filepath;
	__mask = _mask;
	__attr = _attr;
	__callback_per_file = _callback_per_file;
	
	static __FirstFile = function() {
		__file = file_find_first(__mask, __attr);	
		__thread.PushNext(method(self, __HandleFile));
	}
	
	static __HandleFile = function() {
		if (__file != "") {
			__callback_per_file(__filepath, __file);
		}
		
		if (__file == "") {
			file_find_close();
			exit;
		}
		
		__file = file_find_next();
		__thread.PushNext(method(self, __HandleFile));
	}
	
	__thread.Push(method(self, __FirstFile));
}