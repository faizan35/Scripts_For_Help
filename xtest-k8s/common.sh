#!/bin/bash




# Add Docker's official GPG key:
sudo apt-get update

sudo apt-get install -y ufw git curl unzip tree apt-transport-https ca-certificates gnupg-agent software-properties-common

sudo ufw allow 6443
sudo ufw enable



# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab



# Install containerd runtime
sudo apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y containerd.io

# Configure containerd to use systemd
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd

# Add Kubernetes repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"

# Install Kubernetes components
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



# =================================   PORT   ====================================



sudo ufw status

#####################################################################