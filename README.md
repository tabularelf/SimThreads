# SimThreads v1.1.0
Parallel Execution in GameMaker

Example:
```gml
// Create Event
thread = new SimThread();
thread.SetMaxTime(.005);
entriesList = array_create(10000, "the pug is never the end ");
buffer = buffer_create(1, buffer_grow, 1);
// Write a bunch of data to said buffer
var _len = array_length(entriesList);
var _i = 0;
repeat(_len) {
  thread.Push({
   callback: buffer_write,
   args: [buffer, buffer_text, entriesList[_i++]]
  });
}

thread.Push(function() {
  buffer_save(buffer, "mytext.txt");
  show_debug_message("Buffer saved!");
  buffer_delete(buffer);
});
```

```gml
// Game End Event
thread.Flush();
```
