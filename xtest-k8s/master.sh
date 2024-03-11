#!/bin/bash

# sudo kubeadm init

# # kubeadm init --apiserver-advertise-address 192.168.0.11 --pod-network-cidr 10.0.0.0/16

# # kubeadm init --control-plane-endpoint 192.168.0.11

# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config


# # sudo kubeadm token create --print-join-command

# Initialize Kubernetes cluster
sudo kubeadm init --control-plane-endpoint >> /home/ubuntu/k8s-cluster.output

# Configure kubectl for non-root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico Pod Network Add-on
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml




# =================================   PORT   ====================================

# Allow 6443
sudo ufw allow 6443

sudo ufw enable
sudo ufw status


#####################################################################
