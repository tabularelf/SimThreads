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

str = "Hello World!";
thread = new SimThread();
//thread.SetMaxTime(.001);

thread.Push(function() {
		show_debug_message("Begin!");
});

thread.Push(function() {
	show_debug_message("One!");	
	
	thread.PushNext(function() {
		show_debug_message("Two!");
	});
	
	thread.PushNext(function() {
		show_debug_message("Three!");
	});
	
	thread.PushNext(function() {
		show_debug_message("4?!");
	});
});

entriesList = array_create(100000, "the pug is never the end ");
buffer = buffer_create(1, buffer_grow, 1);
// Write a bunch of data to said buffer
var _len = array_length(entriesList);
thread.Loop(_len, function(_pos) {
	buffer_write(buffer, buffer_text, entriesList[_pos]);
}, SimCallback(function(_buffer) {
  show_debug_message("Buffer saved!");
  buffer_delete(_buffer);
}, [buffer]));