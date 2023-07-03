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
			if (_response.catchCallback != undefined) {
				_response.catchCallback(_ex);
			} else {
				// No catch statement, throw it!
				throw _ex;	
			}
			_response.__forceBreak = true;
		} 
	}
	
	if (_response.__forceBreak || _response.__finished) {
		if (_response.finallyCallback != undefined) {
			_response.finallyCallback();	
		}
		return true;
	}
	
	return false;
}	