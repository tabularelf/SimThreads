/// @ignore
/// @feather ignore all
#macro __SIMTHREAD_VERSION "v3.0.3 Beta"
show_debug_message("SimThread " + __SIMTHREAD_VERSION + ": Initalized! Created by @TabularElf - https://tabelf.link/");

#macro SIMTHREAD_POS (SimThreadTaskGetCurrentPosition())

#macro SIMTHREAD_CURRENT_TASK (SimThreadGetCurrentTask())

#macro SIMTHREAD_CURRENT_RESPONSE \
	__SimThreadTrace("\"SIMTHREAD_CURRENT_RESPONSE\" is deprecated! Please use \"SIMTHREAD_CURRENT_TASK\" instead!"); \
	SimThreadGetCurrentTask()

#macro SIMTHREAD_CURRENT_THREAD (SimThreadTaskGetCurrentThread())

function __SimThreadSystem() {
	static _inst = {
		pos: 0,
		currentResponse: undefined,
		currentThread: undefined,
	};
	return _inst;
}