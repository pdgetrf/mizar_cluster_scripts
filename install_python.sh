#!/bin/bash
PYTHON_VERSION=${PYTHON_VERSION:-"3.7.12"}

# Install python 3.7.12 since apt install always install python3.7.5
sudo apt update -y
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget libbz2-dev

sudo apt-get remove -y --purge python3.7

cd /tmp; 
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar -xf Python-${PYTHON_VERSION}.tgz
rm -rf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations
sudo make install
python3 --version
