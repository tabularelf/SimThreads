# SimThreads v2.0.0 Alpha
Parallel Execution for GameMaker 2022.5+

### Quick Disclaimer!
This is not "true multithreading". This is merely allowing code to be broken down and spread across several of frames, as oppose to having a massive for loop and manipulating lots of data all within a step.

If you need any assistance, I'd recommend that you join [My Discord Server, TabularElf's Treehouse](https://discord.gg/ThW5exp6r4) under `💻│gamemaker-libraries`.<br>
Or if you're in [GameMaker Kitchen](https://discord.gg/8krYCqr), check out `your_libraries🧶` for the thread discussion!

Allows multiple execution of functions/methods or block of codes, with arguments provided optionally! This is done by having a handy dandy time_source implementation and custom function to execute functions with arguments (as `script_execute_ext` only works for GML functions and methods, not runtime functions.)
SimThreads has two major kinds of support: Direct calling a method and passing in a function/method with arguments.

The use cases for SimThreads allows one to basically push any sort of function/functions and process each set of functions over the next couple of frames.

This can be applied to concepts such as:

-Reading/Writing from data structures/buffers/arrays<br>
-World Gen<br>
-Saving/Loading (within reason)<br>
-Anything that could be processed over the course of a couple frames.<br>

Ues case:

`thread = new SimThread([MaxExecutions]);`

By default, SimThreads has a MaxExecution of `infinity` and will process every function/method in its queue until it hits the max thread time (as set by `.SetMaxTime(percent)`, which is default to `100%`, or `1`).

SimThreads can have a function, method or struct passed as a valid argument for both `.Push()` and `.Insert()` (see down below more for the arguments on those functions)

To push a function to a SimThread, you can do.
```gml
thread.Push(myGMLFunction);
```

To push a method to a SimThread, you can do.
```gml
thread.Push(myMethod);

// Or

thread.Push(method(self, myGMLFunction));

// Or

thread.Push(function() {
  show_debug_message("Hello World from " + string(self)));
});
```

To push a function/method to a SimThread with arguments, you provide:

```gml
thread.Push({
  callback: myGMLFunction,
  args: ["Hello World!"]
});

// Or 

thread.Push(SimCallback(myGMLFunction, ["Hello World!"]));
```

Giving you the ultimate flexibility in however you want to handle your games logic!


# Example:
```gml
// Create Event
thread = new SimThread();
thread.SetMaxTime(.005);
entriesList = array_create(10000, "the pug is never the end ");
buffer = buffer_create(1, buffer_grow, 1);
// Write a bunch of data to said buffer
var _len = array_length(entriesList);
i = 0;
thread.Loop(_len, function() {
  buffer_write(buffer, buffer_text, entriesList[i]);
  ++i;
}).Finally(function() {
  buffer_save(buffer, "mytext.txt");
  show_debug_message("Buffer saved!");
  buffer_delete(buffer);
});
```

```gml
// Game End Event
thread.Flush();
thread.Destroy();
```

# Methods:

## `.Pause()`

Pauses the SimThread execution.

## `.Resume()`

Resumes the SimThread execution.

## `.SetMaxTime(percent)`

Sets the max time a given SimThread can execute (with `percent` being a value between `0` to `1`) per step.

## `.SetMaxExecution(number)`

Sets the max amount of executions per step. `infinity` is set by default. Any number above `0` will limit the SimThread to that number of function executions.

## `.Loop(size, callback)`

Begins looping a callback until X size is reached. This hooks onto the `.While()` method of `__SimResponseClass`.

Returns: Instance of `__SimResponseClass`.

## `.Insert(position, callback)`

Inserts a function/method or struct to a set position within the SimThread.

Returns: Instance of `__SimResponseClass`.

## `.Push(callback)`

Pushes one or multiple functions/methods or structs, adding at the end of the queue.

Returns: Instance of `__SimResponseClass`.

## `.PushNext(callback)`

Pushes the next callback immediately behind this one.

Returns: Instance of `__SimResponseClass`.

## `.Clear()`

Clears the SimThread queue.

## `.Destroy()`

Frees the SimThread queue.

## `.GetQueueLength()`

Gets the length of the SimThread queue.

## `.Flush()`

Flushes all functions (aka executes all functions/methods) within the queue, regardless of the settings of `.SetMaxTime()` and `.SetMaxExecutions()`, and regardless if it's paused or not.

## `.Break()`

Forces the Simthread to stop whatever code is being executed during the response (in the case of a loop).<br>
Note: This only interrupts the loop, but not the current callback that's still processing. You will need to call `return;` or `exit;` to exit out of the callback.


# `__SimResponseClass` methods.

## `.While(callback)` 

Used to indicate whether it should rerun the callback or not, before the callback is executed.

Return: `self`

## `.Until(callback)` 

Used to indicate whether it should rerun the callback or not, after the callback is executed.

Return: `self`

## `.Catch(callback)`

Used to handle errors (if any).

## `.Finally(callback)`

Used to fire off an additional callback after the main callback has finished either successfully, has errored out or has called `.Break()`.

Return: `self`
