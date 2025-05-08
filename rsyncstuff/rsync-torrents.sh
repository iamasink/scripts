#!/bin/bash

LOGFILE="/tmp/rsync.log"

while true; do
    # Clear the log file
    > "$LOGFILE"
    
    # Run rsync with forced line buffering and tee its output to the log file.
    stdbuf -oL rsync -avvz --progress --no-whole-file --partial --inplace \
      -e "ssh -T -o Compression=no -x -i /cygdrive/c/users/lily/.ssh/id_ed25519" \
      lily@192.168.0.81:/home/lily/syncthings/torrents/ \
      /cygdrive/c/users/lily/sync/torrents | tee "$LOGFILE"

    # After rsync finishes, check the log for file transfer markers ("xfr#")
    if grep -q "xfr#" "$LOGFILE"; then
        echo "Changes detected, pausing for 1 minute..."
        read -t 60 -p "Press any key to skip the wait and continue..." key
    else
        echo "No changes detected, pausing for 15 minutes..."
        read -t 900 -p "Press any key to skip the wait and continue..." key
    fi
done
