#! /bin/bash

parseArgs() {
    while getopts c:r:nBR opt
    do
        case $opt in
            c)
                CROP_COORDINATES=$OPTARG    
                ;;
            r)
                RESIZE_SCALE=$OPTARG
                ;;
            n)
                NORMALIZE=1
                ;;
            B)
                SUBMIT_BATCH=1
                ;;
            R)
                RECURSIVE=1
                ;;
            \?)
                echo "Invalid Option: $OPTARG"
                exit 1
                ;;
        esac
    done
}

callMatlabFcn() {
    matlab -nosplash -nodesktop -r 
}

main() {
    parseArgs
    callMatlabFcn
}