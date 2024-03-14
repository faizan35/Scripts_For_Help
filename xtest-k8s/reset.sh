#!/bin/bash

# Stop Kubernetes Services
sudo systemctl stop kubelet

# Reset Kubernetes Configuration
sudo kubeadm reset -f

# Remove Kubernetes Binaries and Configurations
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/kubernetes/

# Start Kubernetes Services
sudo systemctl start kubelet

echo "K8s Reset Done.!"