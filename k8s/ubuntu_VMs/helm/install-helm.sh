#!/bin/bash

# Download Helm GPG signing key and add it to keyrings
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

# Install apt-transport-https package
# allows to download packages over HTTPS
sudo apt-get install apt-transport-https --yes

# Add Helm repository to sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Update apt package list
sudo apt-get update

# Install Helm
sudo apt-get install helm
