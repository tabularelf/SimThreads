/// @func SimCallback(callback, [args])
/// @param callback
/// @param args
function SimCallback(_callback, _args = []) {
    return new __SimCallback(_callback, _args);
}

function __SimCallback(_callback, _args = []) constructor {
	callback = _callback;
	args = _args;
}