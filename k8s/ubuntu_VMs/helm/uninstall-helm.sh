#!/bin/bash

# Uninstall Helm
sudo apt-get remove --purge helm

# Remove Helm repository configuration
sudo rm /etc/apt/sources.list.d/helm-stable-debian.list

# Remove Helm GPG key
sudo rm /usr/share/keyrings/helm.gpg

# Update apt package list
sudo apt-get update
