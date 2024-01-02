#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

# If you need public access to API server using the servers Public IP address, change PUBLIC_IP_ACCESS to true.

PUBLIC_IP_ACCESS="true"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

# Cleanup previous CRI-O installation
sudo apt-get remove --purge cri-o cri-o-runc -y
sudo rm -rf /etc/cni/net.d/*

# Manually pull required images using Docker
sudo docker pull k8s.gcr.io/kube-apiserver:v1.28.5
sudo docker pull k8s.gcr.io/kube-controller-manager:v1.28.5
sudo docker pull k8s.gcr.io/kube-scheduler:v1.28.5
sudo docker pull k8s.gcr.io/kube-proxy:v1.28.5
sudo docker pull k8s.gcr.io/pause:3.6
sudo docker pull k8s.gcr.io/etcd:3.4.18-0
sudo docker pull k8s.gcr.io/coredns/coredns:v1.8.5

# Initialize kubeadm based on PUBLIC_IP_ACCESS
if [[ "$PUBLIC_IP_ACCESS" == "false" ]]; then
    MASTER_PRIVATE_IP=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)
    sudo kubeadm init --apiserver-advertise-address="$MASTER_PRIVATE_IP" --apiserver-cert-extra-sans="$MASTER_PRIVATE_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap --cri-socket=/var/run/docker.sock

elif [[ "$PUBLIC_IP_ACCESS" == "true" ]]; then
    MASTER_PUBLIC_IP=$(curl ifconfig.me && echo "")
    sudo kubeadm init --control-plane-endpoint="$MASTER_PUBLIC_IP" --apiserver-cert-extra-sans="$MASTER_PUBLIC_IP" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap --cri-socket=/var/run/docker.sock

else
    echo "Error: MASTER_PUBLIC_IP has an invalid value: $PUBLIC_IP_ACCESS"
    exit 1
fi

# Configure kubeconfig
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Calico Network Plugin
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
curl https://docs.projectcalico.org/manifests/custom-resources.yaml -O
kubectl create -f custom-resources.yaml
