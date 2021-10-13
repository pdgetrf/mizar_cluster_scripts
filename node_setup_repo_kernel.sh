#!/bin/bash

set -x

cd ~

git clone https://github.com/CentaurusInfra/mizar.git

cd mizar/

git checkout eb839b06f6a92e479d4e64e3eef5d5a609595753 -b edge-work

./kernelupdate.sh

