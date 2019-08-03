A Bash program for Linux that watches a Minecraft server, kicking it back to life,  
every time it fails.  

**Features:**  
*  Interactive, communicates happenings to players.
*  Responsive, heavily multithreaded.
*  Modular, functionality can be easily expanded.
*  Controllable, with full locking and module toggling.
*  Available, being a watchdog, it must never crash.

For more information, run watchdog -h once installed.

To install:
* Clone this repository and go to its folder: `git clone https://gitlab.com/FullyToasted/toasted-watchdog.git; cd toasted-watchdog`
* Mark as executable: `chmod +x watchdog`
* Run installer: `./watchdog`