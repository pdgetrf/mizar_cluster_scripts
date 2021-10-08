#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Format to use:"
    echo "hex2ip.sh [hex]"
    exit
fi

python util_hex2ip.py $1 
