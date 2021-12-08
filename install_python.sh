#!/bin/bash

# Install python 3.7.12 since apt install always install python3.7.4
sudo apt update -y
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget libbz2-dev

sudo apt-get remove -y --purge python3.7

cd /tmp; 
wget https://www.python.org/ftp/python/3.7.12/Python-3.7.12.tgz
tar -xf Python-3.7.12.tgz
rm -rf Python-3.7.12.tgz
cd Python-3.7.12
./configure --enable-optimizations
sudo make install
python3 --version
