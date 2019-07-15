#!/bin/bash
# External Modules for ToastedWatchdog
# Will be run ONCE in the start of the main loop
# If you can't fit something you need here, look into editing the watchdog itself!
# Functions must be referenced in watchdog.cfg

export daemonized=$daemonized

asyncCrashLoopDetection(){
echo "(debug) asyncCrashLoopDetection is running"
declare -i timeAlive=0
while true; do
isRunning=$(cat .wcld.com)
sleep 1
        if [ "$isRunning" == "yes" ]; then
        ((timeAlive++))
        else
        timeAlive=0
        fi
if [ "$timeAlive" -gt 220 ]; then
rm $wcld 2>/dev/null; break; exit 0
fi
echo "timeAlive="$timeAlive > $wcld
done
}

simpleCrashLoopDetection(){
# Attempt to detect a crash loop and lock the watchdog in case. 
# Warn staff, as well.
echo "(debug) simpleCrashLoopDetection is running"
msg=" §2[ToastedWatchdog]§r §aLoaded §amodule: Crash-Loop Prevention"; broadcast
wcld=".wcld.lock"
rm $wcld 2>/dev/null
export daemonized=$daemonized
#isRunning="no" #debug
while true; do
isRunning=$(cat .wcld.com)
sleep 2.5
if [ ! -f $lock ]; then
        if [ "$isRunning" == "no" ]; then
        touch $wcld
        isTracking="yes"
        fi
sleep 1
        if [ "$isTracking" == "yes" ]; then
        isTracking="no"
        if [ -f "$wcld" ]; then
        asyncCrashLoopDetection &
        fi
        sleep 220
                if [ -f "wcld" ]; then
                chmod +x $wcld
                . $wcld
        if [ "$timeAlive" -lt 200 ]; then
        # locking watchdog and reporting crash loop
        rm $wcld 2>/dev/null
        isTracking="no"
        touch $lock
        cldDate=$(date)
        cldAppend=$(echo "(check) Detected crash loop, locking! ")
        cldLog=$cldAppend$cldDate >> $logfile
        echo "(check) Detected crash loop, locking!"
        daemonized="true"
        msg=" §4[ToastedWatchdog]§r Crash loop detected! Please contact administration."; broadcast
        else
        rm $wcld 2>/dev/null
        isTracking="no"
                        if [ "$daemonized" == "false" ]; then
                        echo "(debug) asyncCrashDetection timed out!"
                        fi
        fi
                fi
    
        fi
fi
done

}


