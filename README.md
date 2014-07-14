grayLabTools
============

This repository contains a compilation of the scripts and programs I've created and found useful for the various things I've worked on while at the lab.  This README describes the files contained, and provides instructions on where to find the repositories containing the actual software I've created during my coops, and how to download them.

## Installing the tools



## /conditioningCage

This directory contains scripts useful for working with the conditioning cage system, and the data generated by it.

### Working with the Pis using ssh

#### Accessing the conditioning cage subnet
The raspberry pis can be accessed for maintenence or troubleshooting using ssh.  If you want to access the pis without physically connecting to the switch in the behavioral room, you must first ask Donardo Marcellus (Donardo_Marcellus@hms.harvard.edu) to give your computer a fixed IP address and access to the 10.117.33.0/24 subnet.  To do this, you will have to provide Donardo with your computer's MAC address which can be obtained by typing the following command into a terminal:

`ifconfig en0 | grep ether`

on mac OS X 10.9, or

`ifconfig eth0 | grep HWaddr`

on Ubuntu 14.04

#### Connecting to a \pi
Once you have access, the pis can be accessed using ssh.  The domain names for the pis follow the form:

`graylabpiX.med.havard.edu`

Where 'X' is currently 0 - 9.

The username for each raspberry pi is the factory default: 'pi'.

To log in to graylabpi5, type the following command:

`ssh pi@graylabpi5.med.harvard.edu`

Type yes, then enter the password (ask Jesse if you don't what it is)

To get a list of the raspberry pis currently connected to the 10.117.33.0/24 subnet, use the getConnectedCages.sh script.  If you have run the install script, you can run it like this:

`getConnectedCages`

Otherwise, run it like any other executable bash script:

`path/to/grayLabTools/conditioningCage/getConnectedCages.sh`

After a few seconds, this should produce output similar to this:

`graylabpi2.med.harvard.edu graylabpi4.med.harvard.edu graylabpi5.med.harvard.edu graylabpi6.med.harvard.edu graylabpi7.med.harvard.edu`

