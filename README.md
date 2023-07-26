# SimThreads v2.0.1 Beta
Parallel Execution for GameMaker LTS+

### Quick Disclaimer!
This is not "true multithreading". This is merely allowing code to be broken down and spread across several of frames, as oppose to having a massive for loop and manipulating lots of data all within a step.

If you need any assistance, I'd recommend that you join [My Discord Server, TabularElf's Treehouse](https://discord.gg/ThW5exp6r4) under `💻│gamemaker-libraries`.<br>
Or if you're in [GameMaker Kitchen](https://discord.gg/8krYCqr), check out `other_tubularelf_repos`!

Allows multiple execution of functions/methods or block of codes, with arguments provided optionally! This is done by having a handy dandy time_source implementation and custom function to execute functions with arguments (as `script_execute_ext` only works for GML functions and methods, not runtime functions.)
SimThreads has two major kinds of support: Direct calling a method and passing in a function/method with arguments.

The use cases for SimThreads allows one to basically push any sort of function/functions and process each set of functions over the next couple of frames.

This can be applied to concepts such as:

-Reading/Writing from data structures/buffers/arrays<br>
-World Gen<br>
-Saving/Loading (within reason)<br>
-Anything that could be processed over the course of a couple frames.<br>

Docs are currently being written.