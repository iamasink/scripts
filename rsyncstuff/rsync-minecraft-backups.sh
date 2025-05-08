#!/bin/bash

LOGFILE="/tmp/rsync.log"

while true; do
    # Clear the log file
    > "$LOGFILE"
    
    # Run rsync with forced line buffering and tee its output to the log file.
    stdbuf -oL rsync -avvz --progress --no-whole-file --partial --inplace \
      -e "ssh -T -o Compression=no -x -i /cygdrive/c/users/lily/.ssh/id_ed25519" \
      lily@192.168.0.81:/mnt/storage/mcbackup \
      /cygdrive/c/users/lily/sync/ | tee "$LOGFILE"

    # After rsync finishes, check the log for file transfer markers ("xfr#")
    if grep -q "xfr#" "$LOGFILE"; then
        echo "Changes detected, pausing for 65 minutes..."
        read -t 3900 -p "Press any key to skip the wait and continue..." key
    else
        echo "No changes detected, pausing for 120 minutes..."
        read -t 7200 -p "Press any key to skip the wait and continue..." key
    fi
done
