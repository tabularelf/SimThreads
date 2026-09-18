// feather ignore all

/// @return {Real}
function SimThreadTaskGetCurrentPosition() {
	static _global = __SimThreadSystem();
	if (is_undefined(_global.currentResponse)) show_error("Cannot use SimThreadTaskGetCurrentPosition() outside of SimThreads!", true);

	return _global.pos;
}