#!/bin/bash




# Add Docker's official GPG key:
# sudo apt-get update

# sudo apt-get install -y ufw

# sudo ufw allow 6443
# sudo ufw enable

##########################


# Common setup for all servers (Control Plane and Nodes)

set -euxo pipefail

# Disable swap
sudo swapoff -a

# Keep the swap off during reboot
(sudo crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | sudo crontab -

sudo apt-get update -y

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install CRIO Runtime
sudo apt-get update -y
sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates ufw

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key |
    gpg --dearmor -o /etc/apt/trusted.gpg.d/cri-o.gpg
echo "deb [trusted=yes] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" |
    sudo tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update -y
sudo apt-get install -y cri-o

sudo systemctl daemon-reload
sudo systemctl enable crio --now
sudo systemctl start crio.service

echo "CRI runtime installed successfully"

# Add Kubernetes APT repository and install required packages
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl jq





# =================================   PORT   ====================================



sudo ufw status

#####################################################################