#!/bin/bash

# Remove existing sources.list
sudo rm /etc/apt/sources.list

# Add new repository entry
echo "deb http://ftp.iitm.ac.in/ubuntu/ jammy main" | sudo tee /etc/apt/sources.list > /dev/null

# Update package lists
sudo apt update
