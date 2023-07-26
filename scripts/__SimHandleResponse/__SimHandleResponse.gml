function __SimHandleResponse(_response) {
	if (!_response.__forceBreak) {
	
		try {
			if (_response.whileCallback != undefined) {
				if (!_response.whileCallback(_response.__pos)) {
					_response.__finished = true;	
				}
			}
			
			if (!_response.__finished) {
				__SimThreadFuncExec(_response.callback.callback, _response.callback.args);
				if (_response.untilCallback == undefined && _response.whileCallback == undefined) {
					_response.__finished = true;	
				}
				
				if (_response.untilCallback != undefined) {
					if (_response.untilCallback()) {
						_response.__finished = true;	
					}
				}
				
				if (_response.__inLoop) {
					++_response.__pos;	
				}
			}
		} catch(_ex) {
			if (array_length(_response.catchCallback) > 0) {
				var _i = 0;
				repeat(array_length(_response.catchCallback)) {
					_response.catchCallback[_i](_ex);	
					++_i;
				}
			} else {
				// No catch statement, throw it!
				throw _ex;	
			}
			_response.__forceBreak = true;
		} 
	}
	
	if (_response.__forceBreak || _response.__finished) {
		if (array_length(_response.finallyCallback) > 0) {
			var _i = 0;
			repeat(array_length(_response.finallyCallback)) {
				_response.finallyCallback[_i]();	
				++_i;
			}
		}
		return true;
	}
	
	return false;
}