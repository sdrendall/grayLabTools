#! /bin/bash

ensureDir() {
    if [ ! -d $1 ]
        then
        mkdir $1
    fi
}

syncVideos() {
# Get connected cage hostnames
for pi in $(nmap -sP 10.117.33.* | egrep 'graylabpi[1-8]' | cut -d ' ' -f 5)
do
    hn=$(ssh pi@$pi 'echo $HOSTNAME')
    vidDest="/media/HMSGenetics/GrayLab/SamRendall/conditioningCage/videoArchive/$hn"
    ensureDir $vidDest
    sudo rsync -avz --remove-source-files pi@$pi:~/fc_videos/ $vidDest
done
}

# Make sure filesystem is mounted
if [ ! -d "/media/HMSGenetics/GrayLab/SamRendall" ]
    then
    sudo mount /media/HMSGenetics/GrayLab/
fi

syncVideos