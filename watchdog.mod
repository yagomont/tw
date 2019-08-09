#!/bin/bash
#/* Copyright (C) 2018-2019 Fully Toasted <fully.toasted.community@gmail.com> - All Rights Reserved
# *
# * This file is part of Toasted Watchdog by Fully Toasted, Toasted Watchdog is Proprietary and Confidential.
# * Unauthorized copying of this file, project, and associated files via any medium is strictly prohibited.
# *
# * Written by Fully Toasted.
# */
# Will be loaded ONCE in the start of the main loop
# If you can't fit something you need here, look into editing the watchdog itself!
# Functions must be referenced in watchdog.cfg to actually run.

        . watchdog.setup.cfg 2>/dev/null
        set -a

serverRestartScheduler(){
loadVars;
# Schedule a restart for 5am EDT
echo "[INFO] serverRestartScheduler module running on "$shortPackID
execdir=$(pwd)
export execdir=$execdir
while true; do
sleep $restartSleepTime
atcheck=$(atq | wc -l)
#if [ "$atcheck" -eq "0" ]; then
if [ ! -f ".wdr" ]; then
if [ ! -f $lock ]; then
echo 'bash watchdog.rbs' | at 8:45UTC -M || echo 'bash watchdog.rbs' | at 4:45 -M
touch .wdr
fi
fi
#fi
done
}

cacheLogins(){
loadVars;
echo "[INFO] cacheLogins module running on "$shortPackID
        while true; do
sleep $cacheTime
nline=$(tail -n 12 /home/minecraft/$longPackID/serverfiles/logs/latest.log | grep -i "Sent config to"  -)
nlineCount=$(echo "$nline" | wc -l)
                if [ "$nlineCount" == "1" ]; then
pGetPlayer=${nline%".'"}
pGetPlayer=${pGetPlayer##*\'}
checkIsCached=$(cat playerLoginCache | grep -i $pGetPlayer | wc -l)
if [ ! "$checkIsCached" -gt 0 ]; then
echo $pGetPlayer >> playerLoginCache
        if [ "$doCommandOnNewLogin" == "true" ]; then
export command=$commandOnNewLogin; command=$commandOnNewLogin; sendCommand ;
        fi
fi
                fi
        done
}

grabWhitelist(){
loadVars;
echo "[INFO] grabWhitelist module running on" $shortPackID
whitelistTime=$((whitelistTimeMins * 60))
while true; do
sleep $whitelistTime
scp minecraft@51.79.37.10:/home/minecraft/whitelistserver/serverfiles/whitelist.json .
tmux send -t $shortPackID "whitelist reload" ENTER
mv -f whitelist.json /home/minecraft/$longPackID/serverfiles/whitelist.json
done
}

saveHandler(){
loadVars;
echo "[INFO] saveHandler module running on" $shortPackID
saveHandlerTime=$((saveHandlerTimeMins * 60))
while true; do
msgAppend="Cleaning memory and saving the world. This will lag a bit."; broadcastInternal;
command="save-all"; export command=$command; sendCommand;

        if [ "$doFullGC" == "true" ]; then
        command="pregen utils gc"; export command=$command; sendCommand;
        echo "[INFO] saveHandler: Enabled GC mode."
        fi
        sleep $saveHandlerTime
done
}

announceHandler(){
        source watchdog.setup.cfg
echo "[INFO] announceHandler module running on" $shortPackID
while true; do
sleep 2800
msgAppend="You are playing $pack on Fully Toasted."; broadcastInternal;
msgAppend="Is the server lagging or having problems?"; broadcastInternal;
msgAppend="If it is, tag our @Staff on Discord!"; broadcastInternal;
if [ "$announcement" != "" ]; then
                        loadnow=$(echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')])
                        memtotal=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
                        usemem=$(awk '/MemFree/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
                        usemem=$(bc <<< "scale=2; $memtotal - $usemem");
                        totalmem=$(bc <<< "scale=2; $memtotal * 1" );
        sleep $announcementDelay
        msgAppend=$announcement; broadcastInternal

fi

sleep 500
done
}

