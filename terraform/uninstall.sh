#!/bin/bash

# Uninstall Terraform
sudo apt-get purge -y terraform

# Remove the HashiCorp GPG key and repository
sudo rm /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo rm /etc/apt/sources.list.d/hashicorp.list

# Update package list without the HashiCorp repository
sudo apt update

echo "------- Terraform uninstalled -------"
