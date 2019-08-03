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

        set -a

serverRestartScheduler(){
loadVars;
# Schedule a restart for 5am EST
echo "[INFO] serverRestartScheduler module running on "$shortPackID
execdir=$(pwd)
export execdir=$execdir
while true; do
sleep $restartSleepTime
atcheck=$(atq | wc -l)
#if [ "$atcheck" -eq "0" ]; then
if [ ! -f ".wdr" ]; then
if [ ! -f $lock ]; then
echo 'bash watchdog.rbs' | at 4:45 -M
touch .wdr
fi
fi
#fi
done
}

cacheLogins(){
loadVars;
echo "[INFO] cacheLogins module running on"$shortPackID
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
while true; do
sleep 300
scp minecraft@51.79.37.10:/home/minecraft/whitelistserver/serverfiles/whitelist.json .
tmux send -t $shortPackID "whitelist reload" ENTER
mv -f whitelist.json /home/minecraft/$longPackID/serverfiles/whitelist.json
done
}

saveHandler(){
loadVars;
echo "[INFO] saveHandler module running on" $shortPackID
#echo "[INFO] packidHandler:" $longPackID
while true; do
sleep 2210
msgAppend="Cleaning memory and saving the world. This will lag a bit."; broadcastInternal;
command="save-all"; export command=$command; sendCommand;

        if [ "$doFullGC" == "true" ]; then
        command="pregen utils gc"; export command=$command; sendCommand;
        fi
done
}

announceHandler(){
loadVars;
echo "[INFO] announceHandler module running on" $shortPackID
while true; do
sleep 5000
msgAppend="Is the server lagging or having problems?"; broadcastInternal;
msgAppend="If it is, tag our @Staff on Discord!"; broadcastInternal;
msgAppend="You may also use /spark healthreport and /spark tps to see how the server is doing."; broadcastInternal;

if [ "announcement" != "" ]; then

        sleep $announcementDelay
        msgAppend="$announcement"; broadcastInternal

fi

sleep 500
msgAppend="Don't forget to check out our new amazing, custom worldgen at /warp spawn3 ! Includes Biomes O' Plenty and RTG features, plus bugfixes."; broadcastInternal;
done
}

