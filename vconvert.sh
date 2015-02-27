#!/bin/bash

# convert any video file to h264 96k AAC
# use tmp for lock file so it automatically clears on system restart

LOCKFILE=/tmp/vconvert.lock
ROOTDIR="/Users/administrator/Desktop/convert"
LOGFILE=$ROOTDIR/vconvert.log
SETTINGS="-c:v h264 -acodec libfdk_aac -b:a 96k -y"

# check if script is already running before proceeding
if [ -e $LOCKFILE ]; then
        date >> $LOGFILE
        echo "Script already running.  Terminating.  Delete $LOCKFILE if you think this is wrong" >> $LOGFILE
        exit
else
        touch $LOCKFILE
fi

# check if output directory alredy exists
if [ ! -e $ROOTDIR/converted ]; then
	mkdir $ROOTDIR/converted
fi

# run through all files, ignore subdirs
for FILE in $(find $ROOTDIR -maxdepth 1 -type f); do
        # check if file is being accessed currently and if error code 0, skip it
        date >> $LOGFILE
        echo "Checking if $FILE is being accessed" >> $LOGFILE
        lsof $FILE
        if [ $? == 0 ]; then
                echo "$FILE is being accessed.  Skipping." >> $LOGFILE
        else
                echo "$FILE ready for conversion using $SETTINGS" >> $LOGFILE
                FILE_NO_EXTENSION=$(echo $FILE | cut -f1 -d.)
                ffmpeg -i $FILE $SETTINGS $ROOTDIR/converted/$FILE_NO_EXTENSION.mp4
        fi
done

# delete lock file
echo "Cleaning up" >> $LOGFILE
rm $LOCKFILE
