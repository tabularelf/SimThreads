/// @description Insert description here
// You can write your code in this editor
show_debug_overlay(true);
thread = new SimThread();
thread.SetMaxExecution(1);
entriesList = array_create(10000, "the pug is never the end ");
buffer = buffer_create(1, buffer_grow, 1);
// Write a bunch of data to said buffer
var _len = array_length(entriesList);
var _i = 0;
repeat(_len) {
  thread.Push({
   callback: buffer_write,
   args: [buffer, buffer_text, entriesList[_i++]]
  });
}

thread.Push(function() {
  buffer_save(buffer, "mytext.txt");
  show_debug_message("Buffer saved!");
  buffer_delete(buffer);
});

//thread.Flush();

/*myMethod = function() {
	var _i = 0;
	var _str = [];
	var _num = 0;
	repeat(1000) {
		_num = 1;	
	}
	repeat(argument_count) {
		_str[_i] = argument[_i];	
		++_i;
	}
	show_debug_message(_str);
}

myOtherMethod = function() {
	return object_get_name(object_index);	
}

repeat(1000) {
	thread.Push({callback: myMethod, args: [irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024), irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024), irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024),irandom(1024)]});	
}

thread.Insert(myMethod, 0);
thread.Push({callback: show_debug_message, args: [myOtherMethod()]});

//show_message(thread.ToArray());