// feather ignore all

/// @return {Struct.SimThread}
function SimThreadTaskGetCurrentThread(){
	var _response = SimThreadGetCurrentTask();
	if (is_struct(_response)) return _response.GetThread();
	
	show_error("Cannot use SimThreadGetCurrentThread() outside of SimThreads!", true);
}