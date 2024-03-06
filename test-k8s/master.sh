#!/bin/bash



sudo kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubeadm token create --print-join-command


# =================================   PORT   ====================================

# Allow 6443
sudo ufw allow 6443

sudo ufw enable
sudo ufw status


#####################################################################
