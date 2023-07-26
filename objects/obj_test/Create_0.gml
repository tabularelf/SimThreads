thread = new SimThread();
thread.SetMaxExecution(1);
i = 0;
draw_enable_drawevent(false);

thread.Loop(10, function() {
	show_debug_message(i);
	++i;
}).Finally(function() {
	show_debug_message("Woot!");	
	thread.Push(function() {
		j += bar;	
	}).Catch(function(_ex) {
		show_debug_message(_ex.message);
	}).Finally(function() {
		show_debug_message("Woot x2!");
		game_end();
	}).Finally(function() {
		show_debug_message("Can this execute?");	
	}).Finally(function() {
		show_debug_message("Yes yes it can!");	
	});
});