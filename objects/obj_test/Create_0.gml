thread = new SimThread();
i = 0;
//draw_enable_drawevent(false);

thread.Loop(1000, function() {
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
	});
});