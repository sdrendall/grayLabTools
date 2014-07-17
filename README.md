grayLabTools
============
This repository contains a compilation of the scripts and programs I've created and found useful for the various things I've worked on while at the lab.  This README describes the installation and usage of the files contained, and provides instructions on where to find the repositories containing the rest of the software I've created during my coops, how to download them.


Downloading the Tools
---------------------
I recommend using git to download and update this repository.  To install git, follow the instructions [here]().  Once you have installed git, open a terminal, and navigate to the directory you would like to download this toolbox to then use the `git clone` command to download the tools.  I keep my code repositories in a directory called 'code' in my home folder, so for me, this entire step would look like this:

```
mkdir ~/code
cd ~/code
git clone https://github.com/sdrendall/grayLabTools
```


Installing the Tools
--------------------
I've included an install script that will install dependencies and create symbolic links to make using these tools easier.  If you are on a mac, you must first install macports, which can be downloaded [here](http://www.macports.org/install.php).  To install the tools, navigate to grayLabTools, then run the `install` script.  For example, if you have the tools in `~/code`, this step would look like this:

```
cd ~/code/grayLabTools
./install
```


Updating the Tools
------------------
I will occasionally make updates to this repository.  To update the code on your computer, you need to pull these updates down from github.  To do this, navigate to your grayLabTools repository, then run the `git pull` command.  If you keep the tools in `~/code`, this step looks like this:

```
cd ~/code/grayLabTools
git pull origin master
```


conditioningCage
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
Once you have access, the pis can be accessed using ssh.  The domain names for the pis follow the form `graylabpiX.med.havard.edu`. Where 'X' is currently 1 - 8.  The username for each raspberry pi is the factory default: 'pi'.

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

I often use this technique to check the status of the timelapses running on the pis, to make sure everything is running correctly.  To do this, run the following command:

`runOnConnectedCages 'echo "$HOSTNAME:"; ps -A | grep raspi'

For each cage with an active timelapse, you will see a line with the cage's name, followed by a line describing the raspistill process responsible for the timelapse.  It should looks similar to this:

```
HCCC5:
2119 ?        00:00:02 raspistill
```

A cage name followed by another cage name means something is wrong.


### Managing files on the fileserver ###

Using the default timelapse period of 10 seconds, each raspberry pi generates 8640 images a day during an experiment.  This can quickly become unmanageable, so I've included a couple scripts to make sifting through these large data sets a bit easier.  These require some setup that I'm not going to get into here, so they may not work on computers other than the image processing workstation


#### Archiving Timelapses ####

`archiveTimelapses.sh` and `archiveTimelapes_macVersion.sh` move timelapses from their initial destiation, `research.files.med.harvard.edu/Genetics/GrayLabPis/incomingTimelapses`, to `research.files.med.harvard.edu/Genetics/GrayLab/SamRendall/timelapseArchive/`.  Timelapses are grouped based on unique timestamps, and saved in directories named accordingly.

#### Sampling Timelapses ####

sampleTimelapses.sh is useful for pulling down a few images from a timelapse (I beleive it is the last 100) to check on the status of mice in the conditioning cages.  This script will pull images from the GrayLabPis share on the fileserver.  **Once images have been archived, this script cannot access them**.  For the time being, this script is designed to be used on the mac in the break room.  Jin knows how to do this.


imageManipulation
------------------

It is often convenient to write scripts to perform simple operations like cropping or resizing on a large set of images, especially if they are large images in the vsi format.  This section will describe how to do this using matlab, and how to run the script on orchestra.

### Configuring matlab

Before using this script, a few minor configuration changes must me made to matlab.  If you don't have matlab, the installer can be found [here](https://wiki.med.harvard.edu/Software/ResearchApplicationDownloads#MATLAB_R2014a).

#### Updating the MATLAB path ####

Once matlab is installed, the first thing to do is add the image manipulation scripts to the matlab path.  This must be done, or matlab will not recognize the functions defined in the image manipulation scripts as valid commands.  There are two ways to do this:

1.) Open matlab.  On toolbar at the top of the console, there is a 'Set Path' option in the 'Enviroment' section.  Click on this.  Choose the 'Add With Subfolders' option, then find where you downloaded the grayLabTools folder and click 'Open'.  Click the 'Save' button at the bottom of the 'Set Path' window, then click close.

2.) Open matlab.  Type the following commands, substituting my example path with the path to the grayLabToolbox folder on your computer:

```
addpath(genpath('path/to/grayLabToolbox'));
savepath()
```

Your matlab path should now include the functions I've included in the grayLabTools repository.

#### Increasing the Java Memory Heap size ####

To load vsi images using matlab, the Java Memory Heap size must be increased from its default value.  To do this, open matlab, select 'Preferences' from the 'Environment' section on the toolbar.  Select MATLAB>General>Java Heap Memory, and set it to a value larger than 1024 MB (I use 2048 on orchestra to be safe, but you can use a bit less if your computer doesn't have much memory).

#### Running the script locally ####

Currently, I've only included one script 'modifyImage.m' in the toolset.  In it's current form, this script loads an image, resizes it to be 2048 pixels in the x dimension, flips it along both axis, converts it to 8-bit (without normalizing it's values) then saves it to an outputpath.  From the matlab command line, it can be run like this:

`modifyImage(inputPath, outputPath)`

If no outputPath is specified, the script will save the output image to the same directory the input image was found in, with the added '_modified' identifier at the end of it's name, in the png format.  I've included quite a few comments to explain what each part of the function is doing, and I've included some extra functions at the bottom that can be used for cropping or normalizing images.  I intend to make a bash command for this function so that different manipulations can be specified with options, rather than by changing the code.  

#### Using the MATLAB on Orchestra ####

##### Configuring MATLAB on Orchestra #####
Orchestra can be used to run this script on many images in parallel to produce results for a large data set very quickly.  However, before using the modifyImage script, the same configuration steps mentioned above must be completed on orchestra while signed into your username.  To do this, you need to enable X11 forwarding by including the `-X` option in your ssh command so that you can run matlab in graphical mode.  This looks something like this:

`ssh -X sr235@orchestra.med.harvard.edu`

Once you are signed into orchestra, you will need to start an interactive session in order to run matlab.  You can do this with the following command:

`bsub -q interactive -R "rusage[mem=16000] -Is bash`

This will start an interactive session with 16GB of RAM.

Once in an interactive session, the `matlab` command can be used to open matlab.  After that, the same steps mentioned [above](https://github.com/sdrendall/grayLabTools#configuring-matlab) can be followed to properly configure matlab.  Once configured, settings will persist after logging off of orchestra.

##### Submitting a job on Orchestra #####

To run the modifyImage script outside of an interactive session, submit to the short queue.  The basic command to do that looks like this:

`bsub -q short -R "rusage[mem=16000]" -W 0:30 matlab -nosplash -nodesktop -r "modifyImage('path/to/inputImage.vsi', 'path/to/outputImage.png'); exit"`

That's great, but this command only modifys a single image, and typing this command for each image in a data set could be just as tedious as performing the desired manipulations manually.  To submit a job for each image in a data set, use a for loop with the find command.  Heres an example:

```
for imagePath in `find /groups/gray/sam/vsiImages -name "*.vsi" -type f`; do bsub -q short -R "rusage[mem=16000]" -W 0:30 matlab -nosplash -nodesktop -r "modifyImage('$imagePath'); exit"; done
```

This would find every vsi image within the vsiImages directory, even those located in subdirectories, and perform some modification on them.  The output images would be saved alongside the input images, in the png format.  To specify a different output path, the `basename` command can be useful.  `basename` takes an input path, and returns just the filename that that path points to.  Here's how I would use `basename` to save all of the output images from the modifyImages script to the same directory:

```
for imagePath in `find /groups/gray/sam/vsiImages -name "*.vsi" -type f`; do filename=`basename $imagePath .vsi`; outputPath="/groups/gray/sam/modifiedImages/$basename_modified.png"; bsub -q short -R "rusage[mem=16000]" -W 0:30 matlab -nosplash -nodesktop -r "modifyImage('$imagePath','$outputPath'); exit"; done
```

To monitor the status of all of your jobs use the `bjobs` command.  To kill all of your jobs use `bkill -u  yourEcommonsId 0`.  For more information on using Orchestra, check out the [Orchestra wiki](https://wiki.med.harvard.edu/Orchestra/)