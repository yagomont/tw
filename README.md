ToastedWatchdog

A script for ToastedNetwork authored by yagoply

A watchdog that restarts a Minecraft server automatically

Will log attempts to /home/minecraft/watchdog.log


Usage:

-d : daemonize, run in as a service in the background

-l : lock, will lock the watchdog preventing it from doing anything

-ul : unlock, will unlock the daemon, restoring functionality.

-k : kills the daemon, use if it goes rogue

-b : broadcast a message to the server

-h : display this message

Run watchdog without arguments for interactive mode. This will let you see what it's doing.

TBD: Crash loop detection