#! /bin/bash

dumpPath="/media/HMSGenetics/GrayLab/SamRendall/conditioningCage/timelapseArchive"
startPath="/media/HMSGenetics/GrayLabPis/incomingTimelapses"

ensureDir() {
    if [ ! -d $1 ]
        then
        mkdir $1
    fi
}

relocateImages() {
    # Extract distinct timelapses
    # Pull smaller samples of the image sets first, to avoid issues with
    #  too many arguments to ls
    for dateAndTimeStamp in $(ls *100.jpg | cut -d'_' -f2,3 | sort | uniq)
    do
        currDumpDir="$2/$dateAndTimeStamp/"
        ensureDir $currDumpDir
        find . -maxdepth 1 -name "*$dateAndTimeStamp*" -type f -print0 |  xargs -0 -L 5000 -P 8 -I % /usr/bin/rsync -avz --remove-source-files % $currDumpDir
    done

    # Final pass to copy over whatever is left
    for dateAndTimeStamp in $(ls *.jpg | cut -d'_' -f2,3 | sort | uniq)
    do
        currDumpDir="$2/$dateAndTimeStamp/"
        ensureDir $currDumpDir
        find . -maxdepth 1 -name "*$dateAndTimeStamp*" -type f -print0 |  xargs -0 -L 5000 -P 8 -I % /usr/bin/rsync -avz --remove-source-files % $currDumpDir
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
        piTlDir="$startPath/$pi"
        relocateImages $piTlDir $piDumpPath
        popd
    fi
done
popd
