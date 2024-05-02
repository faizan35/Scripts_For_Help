#!/bin/bash


sudo apt update

# Install VirtualBox
sudo apt install -y virtualbox docker.io

# Change ownership of Docker socket
sudo chown $USER /var/run/docker.sock

# Download Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb

# Install Minikube
sudo dpkg -i minikube_latest_amd64.deb

# Install kubectl
sudo apt install -y curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "Minikube and kubectl installation completed."
