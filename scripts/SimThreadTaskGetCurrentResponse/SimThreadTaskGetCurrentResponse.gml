// feather ignore all

/// @return {Struct.__SimResponseClass}
function SimThreadTaskGetCurrentResponse() {
	static _global = __SimThreadSystem();
	return _global.currentResponse;
}