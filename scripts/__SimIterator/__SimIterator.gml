function __SimIterator() {
	callback(pos);
	++pos;
	if (pos < size) {
		thread.Push(method(self, __SimIterator));	
	} else {
		if (!is_undefined(final_callback)) __SimThreadFuncExec(final_callback.callback, final_callback.args);
	}
}