#!/bin/bash
# Author: Bhavin Pathak
# OS Detection Launcher

OS="$(uname -s)"
if [ "$OS" = "Linux" ]; then
    echo "Linux detected! Launching Linux Bootstrap..."
    cd linux || exit
    ./genesis.sh
elif [ "$OS" = "Darwin" ]; then
    echo "macOS detected! Launching macOS Bootstrap..."
    cd mac || exit
    ./genesis.sh
else
    echo "Unknown OS: $OS"
    echo "If you are on Windows, please run 'start.bat' or navigate to 'windows' and run 'genesis.ps1'"
fi
