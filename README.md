****Toasted Watchdog 1.5: Apple Jelly****  
A Bash program for Linux that watches a Minecraft server, kicking it back to life,  
every time it fails.  

**Features:**  
*  Interactive, communicates happenings to players.
*  Responsive, heavily multithreaded.
*  Modular, functionality can be easily expanded.
*  Controllable, with full locking and module toggling.
*  Available, being a watchdog, it must never crash.

Includes bonus, non server-keeping features such as broadcasting functionality:  
`watchdog -b` has the prefix [TW/Broadcast], and takes input after being run.  
`watchdog -i` has the prefix [ToastedWatchdog], and takes input from the exported variable `msgAppend`. Mostly for internal use.  

Locking/Unlocking the watchdog is a must for when doing server maintenance. The watchdog should rarely be killed, save for updating it.  
`watchdog -l` locks the watchdog, stopping it from logging anything or doing any actions.  
`watchdog -ul` reverts this.

Has two modes: daemon and interactive, respectively, background and foreground.  
`watchdog` launches interactive mode, silencing broadcasts and outputting extra debug info.  
`watchdog -d` launches daemon mode, enabling full broadcasting and is the recommended mode for production usage. To kill it in this mode, use `watchdog -k`

Currently, has three modules:  
`serverRestartScheduler`, schedules a restart, likely daily, based on the files in `.wtime`.  
`simpleCrashLoopDetection`, detects a crash and uses a simple timer to detect a crash loop. Starts `asyncCrashLoopDetection` for precision.  
`asyncCrashLoopDetection`, detects a crash loop by monitoring the watchdog and keeping track of Minecraft's life time. Shouldn't be enabled all the time.  
To load a module, add its entry in the config file, generally `watchdog.cfg`.  

To recieve help on how to use ToastedWatchdog, run `watchdog -h`