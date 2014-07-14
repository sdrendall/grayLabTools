#! /bin/bash

Dir=/Volumes/genetics/GrayLabPis/incomingTimelapses;

if [ -d $Dir ];
    then
    pushd $Dir
    for pi in *;
    do 
        if [ ! -d ~/timelapseSamples/$pi ];
            then
            mkdir ~/timelapseSamples/$pi;
        fi
        pushd $pi
        rsync -avz `ls $Dir/$pi | egrep '[0-9]{2}100' | tail -n 86` ~/Desktop/timelapseSamples/$pi
        popd
    done
    popd
else
    echo 'Filesystem not mounted!';
fi
