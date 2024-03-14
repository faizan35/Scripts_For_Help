#!/bin/bash

set -euxo pipefail

# Replace the control plane IP with the appropriate IP address
control_plane_ip="192.168.0.11"

sudo kubeadm config images pull

echo "Preflight Check Passed: Downloaded All Required Images"

sudo kubeadm init --apiserver-advertise-address=$control_plane_ip --apiserver-cert-extra-sans=$control_plane_ip --pod-network-cidr=172.16.1.0/16 --service-cidr=172.17.1.0/18 --node-name "$(hostname -s)" --ignore-preflight-errors Swap

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config


kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml


kubeadm token create --print-join-command


#####################################################################
