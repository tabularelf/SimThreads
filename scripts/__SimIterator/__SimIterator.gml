//function __SimIterator() {
//	thread.__currentStruct = self;
//	
//	if (forceBreak) {
//		if (forceCallback) {
//			if (!is_undefined(final_callback)) __SimThreadFuncExec(final_callback.callback, final_callback.args);
//		}
//		thread.__currentStruct = undefined;
//		return;
//	}
//	
//	callback(pos);
//	++pos;
//	if (pos < size) {
//		thread.Push(method(self, __SimIterator));	
//	} else {
//		if (!is_undefined(final_callback)) __SimThreadFuncExec(final_callback.callback, final_callback.args);
//	}
//	thread.__currentStruct = undefined;
//}
//
//function __SimDoUntil() {
//	thread.__currentStruct = self;
//	
//	if (forceBreak) {
//		if (forceCallback) {
//			if (!is_undefined(final_callback)) __SimThreadFuncExec(final_callback.callback, final_callback.args);
//		}
//		thread.__currentStruct = undefined;
//		return;
//	}
//	
//	callback();
//	if (callbackUntil() == true) {
//		if (!is_undefined(final_callback)) __SimThreadFuncExec(final_callback.callback, final_callback.args);
//	} else {
//		thread.Push(method(self, __SimDoUntil));		
//	}
//	thread.__currentStruct = undefined;
//}
//
//function __SimWhile() {
//	thread.__currentStruct = self;
//	
//	if (forceBreak) {
//		if (forceCallback) {
//			if (!is_undefined(final_callback)) __SimThreadFuncExec(final_callback.callback, final_callback.args);
//		}
//		thread.__currentStruct = undefined;
//		return;
//	}
//	
//	if (callbackWhile() == true) {
//		callback();
//		thread.Push(method(self, __SimWhile));		
//	} else {
//		if (!is_undefined(final_callback)) __SimThreadFuncExec(final_callback.callback, final_callback.args);
//	}
//	thread.__currentStruct = undefined;
//}