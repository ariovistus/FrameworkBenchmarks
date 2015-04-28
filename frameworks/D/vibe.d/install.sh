#!/bin/bash

#fw_get 'http://downloads.dlang.org/releases/2015/dmd_2.067.1-0_i386.deb' \
fw_get 'http://downloads.dlang.org/releases/2.x/2.067.1/dmd_2.067.1-0_amd64.deb'
    -O 'dmd_2.067.1-0_amd64.deb'

sudo apt-get install xdg-utils
sudo dpkg -i ./dmd_2.067.1-0_amd64.deb

fw_get 'https://github.com/rejectedsoftware/dub/archive/v0.9.23.tar.gz' \
    -O 'dub-0.9.23.tar.gz'
tar -xf dub-0.9.23.tar.gz
cd dub-0.9.23/

DC=dmd bash build.sh
sudo ln -s `pwd`/bin/dub /usr/local/bin
