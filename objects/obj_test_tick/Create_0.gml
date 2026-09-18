tick = new SimTick(20);
tick.Insert(0, function() {
	show_debug_message("42");
});