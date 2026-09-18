// feather ignore all

/// @return {Struct.__SimTaskClass}
function SimThreadGetCurrentTask() {
	static _global = __SimThreadSystem();
	return _global.currentResponse;
}