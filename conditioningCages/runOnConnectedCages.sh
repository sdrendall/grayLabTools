#! /bin/bash

for cage in `~/code/basics/getConnectedCages.sh`
do
    ssh pi@$cage $1
done
