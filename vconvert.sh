#!/bin/bash

ROOTDIR="/Users/administrator/Desktop"
LOCKFILE=$ROOTDIR/vconvert.lock
SETTINGS="blahblahblah"

# check if system just restarted to clear lock files

# check if script is still running before proceeding
if [ -e $LOCKFILE ]; then
	echo "Script already running.  Terminating."
	#exit
else
	touch $LOCKFILE
fi

# iterate through all files, ignoring hidden files
for FILE in $(find $ROOTDIR -type f -maxdepth 1); do
	# check if file is writable to determine if it is finished copying if [ -w file ]; then
	echo "Checking if $FILE is being accessed"
	lsof $FILE
	if [ $? == 0 ]; then
		echo "$FILE is being accessed.  Skipping."
	else
		echo "$FILE ready for conversion. Execute $SETTINGS"
		echo "Cleaning up"
		# make sure you overwrite in case the system crashed and a lock was cleared on reboot
		# move converted and source files
		# delete lock file
	fi
done
