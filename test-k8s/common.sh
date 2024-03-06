#!/bin/bash

sudo apt-get update

sudo swapoff -a
sudo apt install docker.io -y

sudo systemctl enable --now docker


# k8s 1.27

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


# https://dl.k8s.io/apt/doc/apt-key.gpg

# k8s 1.28

# sudo apt-get update

# sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


# sudo apt update
# sudo apt install -y kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl



############################################################


### Pod Network

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# =================================   PORT   ====================================

# install ufw
sudo apt-get install ufw

# Allow ssh 
sudo ufw allow ssh

sudo ufw enable
sudo ufw status

#####################################################################
