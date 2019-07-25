#!/bin/bash
# External Modules for Toasted Watchdog

 #/* Copyright (C) 2018-2019 Fully Toasted <fully.toasted.community@gmail.com> - All Rights Reserved
 #* 
 #* This file is part of Toasted Watchdog by Fully Toasted, Toasted Watchdog is Proprietary and Confidential.
 #* Unauthorized copying of this file, project, and associated files via any medium is strictly prohibited.
 #* 
 #* Written by Fully Toasted.
 #*/

# Will be run ONCE in the start of the main loop
# If you can't fit something you need here, look into editing the watchdog itself!
# Functions must be referenced in watchdog.cfg
# Export information for the threaded model
 export threadTickTime=$threadTickTime
 export masterThreadTickTime=$masterThreadTickTime
 export threadSpacing=$threadSpacing
 export numThreads=$numThreads
# Export lock files for thread control
 export filew=$filew
 export filex=$filex
 export filey=$filey
# Export configuration
 export logfile=$logfile
        export version=$version
        export lock=$lock
        export cfgfile=$cfgfile
        export modfile=$modfile
        export pack=$pack
        export logfile=$logfile
        export modload=$modload
        export packid=$packid
        export packidAppend=$packidAppend
        export execdir=$execdir

asyncCrashLoopDetection(){
echo "(debug) asyncCrashLoopDetection is running on "$packidAppend
declare -i timeAlive=0
declare -i timeRun=0
while true; do
sleep 1
read isRunning < /tmp/toastedWatchdog_isRunning
        if [ "$isRunning" == "true" ]; then
        ((timeAlive++))
        ((timeRun++))
        else
        timeAlive=0
        ((timeRun++))
        fi
        # when we finish checking, kill the script
                if [ "$timeRun" -gt 500 ]; then
        (( timeAlive + 64 ))
        if [ "$timeAlive" -lt "$timeRun" ]; then
        datecl=$(date)
        echo "(check) Detected crash loop, stopping the watchdog!"
        echo "(log) Detected crash loop @ "$datecl". Watchdog terminated." >> $logfile
        daemonized="true"
        msg=" §4[ToastedWatchdog]§r Crash loop detected! Please contact administration."; broadcast
        . $execdir/watchdog -k -s
        break; exit 1
        else
        break; exit 0
        fi
                fi
done
}

asyncCrashLoopDetectionOld(){
echo "(debug) old asyncCrashLoopDetection is running on "$packidAppend
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
echo "(debug) simpleCrashLoopDetection is running on "$packidAppend
#msg=" §2[ToastedWatchdog]§r §aLoaded §amodule: Crash-Loop Prevention"; broadcast
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
        asyncCrashLoopDetectionOld &
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


serverRestartScheduler(){
# Schedule a restart for 5am EST
#msg=" §2[ToastedWatchdog]§r §aLoaded §amodule: Restart Scheduler"; broadcast
echo "(debug) serverRestartScheduler is running on "$packidAppend
execdir=$(pwd)
export execdir=$execdir
while true; do
sleep $restartSleepTime
atcheck=$(atq | wc -l)
if [ "$atcheck" -eq "0" ]; then
if [ ! -f $lock ]; then
echo 'bash /home/minecraft/.wtime/15minreboot' | at 4:45 -M
fi
fi
done
}



antiVanish(){
# Fixes vanishing players on login on Enigmatica and Revelations
# Has extra force-chunk unloading fucntionality to fix a bug in FTB Utilities
#msg=" §2[ToastedWatchdog]§r §aLoaded §amodule: VanishFix"; broadcast
echo "(debug) antiVanish is running on "$packidAppend
while true; do
#echo "(debug) antiVanish tick"
sleep $vanishSleepTime
nline=$(tail -n 12 /home/minecraft/logs/latest.log | grep -i "Sent config to"  -)
nlineCount=$(tail -n 12 /home/minecraft/logs/latest.log | grep -i "Sent config to"  - | wc -l)
if [ "$nlineCount" == "1" ]; then
pGetPlayer=${nline%".'"}
pGetPlayer=${pGetPlayer##*\'}
VanishPrefix="/v "
VanishSuffix=" no"
ChunkPrefix="sudo "
ChunkSuffix=" chunks unload_all all "$pGetPlayer
pVanishCommand=$VanishPrefix$pGetPlayer
pChunkCommand=$ChunkPrefix$pGetPlayer
pChunkCommand=$pChunkCommand$ChunkSuffix
pVanishCommand=$pVanishCommand$VanishSuffix
if [ "$pIsVanished" == "true" ]; then
        # player is vanished, wait another player.
        if [ "$vanishedPlayer" != "$pGetPlayer" ]; then
        pIsVanished="no"
        sleepTime="1"
fi
else
export command=$pVanishCommand
command=$pVanishCommand
sendCommand ; pIsVanished="true"; vanishedPlayer=$pGetPlayer; sleepTime="5";
fi
         if [ "$doCacheLogins" == "true" ]; then
                  checkIsCached=$(cat playerLoginCache | grep -i $pGetPlayer | wc -l)
                  if [ "$checkIsCached" == "0" ]; then
                  echo $pGetPlayer >> playerLoginCache
                  echo "Cached new player" $pGetPlayer
                        if [ "$doChunkUnloading" == "true" ]; then
                        echo "Unloaded new player's chunks."
                        export command=$pChunkCommand; command=$pChunkCommand; sendCommand ;
                        fi
                  fi
         fi
fi
done

}

grabWhitelist(){
echo "(debug) grabWhitelist running on" $packidAppend
echo "(debug) packidHandler:" $packid
while true; do
sleep 300
. /home/minecraft/$packid/updatewhitelist.sh
mv -f /home/minecraft/$packid/whitelist.json /home/minecraft/$packid/serverfiles/whitelist.json
done
}


