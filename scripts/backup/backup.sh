#!/usr/bin/env bash

# Define the external drives used
VOLUME1="/Volumes/DataVault"
VOLUME2="/Volumes/DataVault2"

# check if DataVault is connected
if [ -d $VOLUME1 ]
then
    echo "$VOUME1 connected"

    # start syncthing in background
    syncthing & disown

    # Run rsync to take backups
    # rsync -a /Volumes/External ~/Dropbox/Backups
    # Notify us that the backup is complete
    # /usr/bin/osascript -e 'display notification "Carry On" with title "rsync Backup Complete"'
    # Or use Growl
    # /usr/local/bin/growlnotify -m 'rsync Backup Complete'
fi
