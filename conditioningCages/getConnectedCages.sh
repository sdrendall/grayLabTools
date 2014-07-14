#! /bin/bash

echo $(nmap -sP 10.117.33.* | egrep 'graylabpi[1-8]' | cut -d ' ' -f 5)