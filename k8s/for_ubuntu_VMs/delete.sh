#!/bin/bash

# Reset Kubernetes on both control-plane and node
sudo kubeadm reset -f

# Remove Docker and Kubernetes packages
sudo apt purge -y docker.io kubeadm kubectl kubelet kubernetes-cni
sudo apt autoremove -y
sudo rm -rf /etc/kubernetes /var/lib/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico

# Reset ufw (firewall)
sudo ufw disable
sudo ufw reset

# Remove Weave networking (if applied)
kubectl delete -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# Remove Kubernetes GPG key and repository
sudo rm /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg
sudo rm /etc/apt/sources.list.d/kubernetes.list

# Remove kubeconfig
rm -rf $HOME/.kube

# Disable & Uninstall UFW
sudo ufw disable
sudo apt-get remove ufw

# Remove ufw dir - for Port
sudo rm -rf /etc/ufw

echo "Kubernetes uninstallation complete."
