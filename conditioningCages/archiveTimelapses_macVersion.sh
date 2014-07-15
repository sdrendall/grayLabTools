#! /bin/bash

dumpPath="/Volumes/genetics/GrayLab/SamRendall/conditioningCage/timelapseArchive"
startPath="/Volumes/genetics/GrayLabPis/incomingTimelapses"

ensureDir() {
    if [ ! -d $1 ]
        then
        mkdir $1
    fi
}

relocateImages() {
    # Extract distinct timelapses
    for dateAndTimeStamp in $(ls *00001.jpg | cut -d'_' -f2,3 | sort | uniq)
    do
        currDumpDir="$1/$dateAndTimeStamp"
        ensureDir $currDumpDir
        find . -name "*$dateAndTimeStamp*" -maxdepth 0 -exec rsync -avz {} $currDumpDir;
    done
}

pushd $startPath
for pi in *
do
    if [ -d $pi ]
        then
        pushd $pi
        piDumpPath="$dumpPath/$pi"
        ensureDir $piDumpPath
        relocateImages $piDumpPath
        popd
    fi
done
popd