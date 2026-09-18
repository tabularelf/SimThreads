function __SimHandleResponse(_response) {
	static _global = __SimThreadSystem();
	if (_response.__cancelled) || (_response.__finished) || (_response.__forceBreak) {
		return true;	
	}
	
	if (!_response.__forceBreak) {
		try {
			if (__frame > _response.__creationFrame + _response.__maxFrameTime) {
				show_error("Max frame time for SimThread process reached!", true);	
			}

			if (_response.__inLoop) {
				__SimThreadSystem().pos = _response.__pos;	
			}

			if (_response.whileCallback != undefined) {
				var _whileResult = _response.whileCallback(_response.__pos);
				if (!_whileResult) {
					_response.__finished = true;	
				}
			}
			
			if (!_response.__finished) {

				
				_global.currentResponse = _response;
				if (is_array(_response.callback.args)) {
					method_call(_response.callback.ptr, _response.callback.args);
				} else {
					_response.callback.ptr();
				}
				_global.currentResponse = undefined;

				if (_response.untilCallback == undefined && _response.whileCallback == undefined) {
					_response.__finished = true;	
				}
				
				if (_response.untilCallback != undefined) {
					if (_response.untilCallback()) {
						_response.__finished = true;	
					}
				}
				
				if (_response.__inLoop) {
					_response.__pos += _response.__incrementor;	
				}
			}
		} catch(_ex) {
			// Safety net
			_global.currentResponse = _response;
			_response.Cancel();
			_response.__forceBreak = true;
			if (array_length(_response.catchCallback) > 0) {
				var _i = 0;
				repeat(array_length(_response.catchCallback)) {
					_response.catchCallback[_i](_ex);	
					++_i;
				}
			} else {
				// No catch statement, throw it!
				var _i = 0;
				repeat(array_length(_response.finallyCallback)) {
					_response.finallyCallback[_i]();	
					++_i;
				}

				_global.currentResponse = undefined;

				throw _ex;	
			}
			_response.__forceBreak = true;
			_global.currentResponse = undefined;
		} 
	}
	
	if (_response.__forceBreak || _response.__finished) && (!_response.__keepAlive) {
		_global.currentResponse = _response;
		if (array_length(_response.finallyCallback) > 0) {
			var _i = 0;
			repeat(array_length(_response.finallyCallback)) {
				_response.finallyCallback[_i]();	
				++_i;
			}
		}

		if (!_response.__cancelled) && (array_length(_response.finishCallback) > 0) {
			var _i = 0;
			repeat(array_length(_response.finishCallback)) {
				_response.finishCallback[_i]();	
				++_i;
			}
		}
		_global.currentResponse = undefined;
		return true;
	}
	
	if (_response.__keepAlive) {
		_response.__finished = false;	
		_response.__forceBreak = false;
	}
	
	return false;
}