thread = new SimThread();
//thread.SetMaxExecution(1);
draw_enable_drawevent(true);

//thread.Push(function(){show_message("HI")});

thread.Loop(10, function() {
	show_debug_message(SIMTHREAD_POS);
}).OnFinish(function() {
	show_debug_message("Woot!");	
	thread.Push(function() {
		SIMTHREAD_CURRENT_TASK.Cancel();
		j += bar;	
	}).OnCatch(function(_ex) {
		show_debug_message(_ex.message);
	}).OnFinally(function() {
		show_debug_message("Woot x2!");
		SIMTHREAD_CURRENT_THREAD.Push(function(){}).OnFinish(function() {
			show_debug_message("Can this execute?");	
		}).OnFinish(function() {
			show_debug_message("Yes yes it can!");	
		});
	})
});