show_debug_overlay(true);
repeat(10) {
	file_find_async(program_directory+"/", "*", 0, function(_path, _mask) {
		var _buff = buffer_load(_mask);
		var _text = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
	});	
}


file_find_async("/", "*.json", 0, function(_path, _mask) {
	var _buff = buffer_load(_mask);
	var _json = json_parse(buffer_read(_buff, buffer_text));
	buffer_delete(_buff);
	show_debug_message(_json);
});

