grayLabTools
============

This repository contains a compilation of the scripts and programs I've created and found useful for the various things I've worked on while at the lab.  This README describes the files contained, and provides instructions on where to find the repositories containing the actual software I've created during my coops, and how to download them.

Installing the tools
--------------------


/conditioningCage
-----------------

This directory contains scripts useful for working with the conditioning cage system, and the data generated by it.


### Working with the Pis using ssh ###

#### Accessing the conditioning cage subnet ####
The raspberry pis can be accessed for maintenence or troubleshooting using ssh.  If you want to access the pis without physically connecting to the switch in the behavioral room, you must first ask Donardo Marcellus (Donardo_Marcellus@hms.harvard.edu) to give your computer a fixed IP address and access to the 10.117.33.0/24 subnet.  To do this, you will have to provide Donardo with your computer's MAC address which can be obtained by typing the following command into a terminal:

`ifconfig en0 | grep ether`

on mac OS X 10.9, or

`ifconfig eth0 | grep HWaddr`

on Ubuntu 14.04


#### Connecting to a pi ####
Once you have access, the pis can be accessed using ssh.  The domain names for the pis follow the form `graylabpiX.med.havard.edu`. Where 'X' is currently 0 - 9.  The username for each raspberry pi is the factory default: 'pi'.

To log in to graylabpi5, type the following command:

`ssh pi@graylabpi5.med.harvard.edu`

Type yes, then enter the password (ask Jesse if you don't what it is)


#### Determining connected cages ####
To get a list of the raspberry pis currently connected to the 10.117.33.0/24 subnet, use the getConnectedCages.sh script.  If you have run the install script, you can run it like this:

`getConnectedCages`

Otherwise, run it like any other executable bash script:

`path/to/grayLabTools/conditioningCage/getConnectedCages.sh`

After a few seconds, this should produce output similar to this:

`graylabpi2.med.harvard.edu graylabpi4.med.harvard.edu graylabpi5.med.harvard.edu graylabpi6.med.harvard.edu graylabpi7.med.harvard.edu`


#### Running commands on the pis ####
ssh can be passed commands to run on the host upon connecting.  For example:

`ssh pi@graylabpi5.med.harvard.edu 'echo "Hello from $HOSTNAME!"'`

Will display a lovely greeting from the host, containing its hostname.

The `getConnectedCages` command is useful for executing commands on each connected raspberry pi.  For example, to recieve the above greeting from each connected pi, you can use the following:

```for connectedCage in `getConnectedCages`; do ssh pi@$connectedCage 'echo "Hello from $HOSTNAME!"'; done```

Such friendly cages!

Writing this whole for loop can get tedious, so I wrote a script -- runOnConnectedCages.sh -- to run commands on each pi, just like we did above.  The following should produce identical results to the previous example:

`runOnConnectedCages 'echo "Hello from $HOSTNAME!"'`

Magnificent!

This can be useful for updating the code on each pi:

`runOnConnectedCages 'cd ~/code/conditioningCage; git pull origin master'`

or for rebooting the pis:

`runOnConnectedCages 'sudo reboot'`

among other things.



### Managing files on the fileserver ###

Using the default timelapse period of 10 seconds, each raspberry pi generates 8640 images a day during an experiment.  This can quickly become unmanageable, so I've included a couple scripts to make sifting through these large data sets a bit easier.  These require some setup that I'm not going to get into here, so they may not work on computers other than the image processing workstation
