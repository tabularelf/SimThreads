/// @func SimCallback(callback, [args])
/// @param callback
/// @param args
function SimCallback(_callback, _args = undefined) {
    return new __SimCallbackClass(_callback, _args);
}