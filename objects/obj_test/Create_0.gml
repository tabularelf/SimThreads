/// @description Insert description here
// You can write your code in this editor
show_debug_overlay(true);
/*tick = new SimTick(20);
tick.Push(function() {
	show_debug_message(1);
});
str = "Hello World!";
tick.Push(function() {
	show_debug_message(2);
});

tick.Insert(0, function() {
	show_debug_message("I execute after 1!");
});

tick.Push(function() {show_debug_message("Hello!");});
tick.Insert(tick.GetMaxTicks(), function() {show_debug_message("And we reset!");});*/


thread = new SimThread();

thread.Push(function() {
	show_debug_message("Hello World!");	
	
	thread.Insert(1, function() {
		show_debug_message("Goodbye world!");
	});
});
/*
// Creates and pushes shared object
var _inst = new SimSharedObject(self, function() {
	show_message_async(str);
});

thread.Push(_inst.Bind(function() {
	str = SIM_SELF.str;
}));

thread.Push(_inst.Bind(function() {
	str = string_delete(str, 1, 6);
}));

thread.Push(_inst.Bind(function() {
	SIM_SELF.str = str;
}));

thread.Push(_inst.Bind(function() {
	End();
}));

entriesList = array_create(10000, "the pug is never the end ");
thread2 = new SimThread();
buffer = buffer_create(1, buffer_grow, 1);
// Write a bunch of data to said buffer
var _len = array_length(entriesList);
var _i = 0;
repeat(_len) {
  thread.Push(SimCallback(buffer_write, [buffer, buffer_text, entriesList[_i++]]));
}

thread.Push(function() {
  buffer_save(buffer, "mytext.txt");
  show_debug_message("Buffer saved!");
  buffer_delete(buffer);
});