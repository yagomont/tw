# /bin/bash
#/* Copyright (C) 2018-2019 Fully Toasted <fully.toasted.community@gmail.com> - All Rights Reserved
# *
# * This file is part of Toasted Watchdog by Fully Toasted, Toasted Watchdog is Proprietary and Confidential.
# * Unauthorized copying of this file, project, and associated files via any medium is strictly prohibited.
# *
# * Written by Fully Toasted.
# */
# Server for the TTK
# WIP
# First, lock the environment so there is only ever 1 server.
set -a

refreshRate="0.03" #In seconds
args="$@"

function stopHandler(){

        echo "[INFO] Stopping server..."; rm $slock 2>/dev/null
        exit 0
}

trap stopHandler INT

slock="/home/minecraft/.sl"

function checkLock(){

if [ -f "$slock" ]; then
        # Just start up the watchdog
        echo "[INFO] Connecting to server..."
        ./wserver.sh -wc

else
        if [ "$args" == "start" ]; then
        echo "[INFO] Starting watchdog server..."
        echo
        touch $slock
        ./watchdog -d
        else
        ./watchdog $args
        serverLoopWrapper;
        fi
fi

}

function serverLockToggle(){

        if [ ! -f "$slock" ]; then
        touch $slock
        echo "[INFO] Lock state updated: locked"
        else
        rm $slock 2>/dev/null
        echo "[INFO] Lock state updated: unlocked"
        fi

        exit 0

}

function serverLoopWrapper(){

tmux new-session -c $(pwd) -n ws -s ws "./wserver.sh -ws"

}

function doConnect(){
tmux -c $(pwd) attach -t ws || echo "[ERROR] Couldn't find watchdog server."
}

function doMainServerLoop(){

sleep 3

}

function doServerWatchLoop(){

serverLoopWrapper & echo "[INFO] Waiting for server..."; sleep 2

while true; do
        sleep $refreshRate;
        screenDraw; 2>/dev/null
done

}

case $1 in

        -ls) serverLockToggle;;
        -ws) doMainServerLoop;;
        -wc) doConnect;; 
        start) checkLock; serverLoopWrapper;;
        *) checkLock;;

esac

