#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

sudo kubeadm config images pull

echo "Preflight Check Passed: Downloaded All Required Images"

sudo kubeadm init

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Save Configs
config_path="/etc/kubernetes"

sudo mkdir -p $config_path/configs
sudo cp -i /etc/kubernetes/admin.conf $config_path/configs/config
sudo chmod 644 $config_path/configs/config

# Install Calico Network Plugin
curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml -O

kubectl apply -f calico.yaml

# Install Metrics Server
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/metrics-server/main/deploy/kubernetes/metrics-server-deployment.yaml



# ================================   PORT   ====================================

# Allow 6443
# sudo ufw allow 6443

# sudo ufw enable
sudo ufw status


#####################################################################
