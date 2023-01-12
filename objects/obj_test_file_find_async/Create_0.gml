file_find_async(program_directory+"/", "*", 0, function(_path, _mask) {
	var _buff = buffer_load(_mask);
	var _text = buffer_read(_buff, buffer_text);
	buffer_delete(_buff);
}, function() {
	show_debug_message("done!");	
});	


file_find_async(working_directory + "/", "*.json", 0, function(_path, _file) {
	var _buff = buffer_load(_path + _file);
	var _json = json_parse(buffer_read(_buff, buffer_text));
	buffer_delete(_buff);
	show_debug_message(_json);
});