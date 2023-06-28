thread = new SimThread();
i = 0;

thread.While(function() {	
	return i < 11;
}, function() {
	show_debug_message("While");
	show_debug_message(i);
	i++;
	
	if (i == 5) || (i == 6) {
		thread.ForceBreak();	
	}
	
});


thread.DoUntil(function() {
	show_debug_message("DoUntil");
	show_debug_message(i);
	i++;
	
}, function() {	
	return i >= 10;
});