#!/bin/bash

# Update package list and install required dependencies
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

# Download HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Display the GPG key fingerprint
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

# Add the official HashiCorp repository to your system. 
# The lsb_release -cs command finds the distribution release codename for your current system, 
# such as buster, groovy, or sid.
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update package list with the new repository
sudo apt update

# Install Terraform
sudo apt-get install terraform



