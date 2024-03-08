#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
apt-get install -y cri-o cri-o-runc

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



cri-dockerd --network-plugin=${plugin}
/usr/lib/systemd/system/cri-docker.service
/etc/systemd/system/multi-user.target.wants/cri-docker.service
systemctl daemon-reload
#######################################
# Define the desired network plugin
network_plugin="weave"

# Check if cri-dockerd binary is available
if ! command -v cri-dockerd &>/dev/null; then
    echo "Error: cri-dockerd binary not found. Make sure cri-dockerd is installed."
    exit 1
fi

# Check if systemd unit file exists
unit_file="/etc/systemd/system/cri-docker.service"
if [ ! -f "$unit_file" ]; then
    echo "Error: systemd unit file '$unit_file' not found."
    exit 1
fi

# Check if the network plugin option already exists in the unit file
if grep -q "network-plugin=$network_plugin" "$unit_file"; then
    echo "Network plugin is already set to $network_plugin. No action needed."
    exit 0
fi

# Add the network plugin option to the ExecStart command in the systemd unit file
sed -i "s|^ExecStart=/usr/local/bin/cri-dockerd |ExecStart=/usr/local/bin/cri-dockerd --network-plugin=$network_plugin |" "$unit_file"

# Reload systemd to apply changes
systemctl daemon-reload

# Restart cri-dockerd service
systemctl restart cri-dockerd

echo "Default network plugin is now set to $network_plugin."

#######################################

# sudo apt install docker.io -y

# sudo systemctl enable --now docker
# apt-get install -y cri-o cri-o-runc

# disable swap
sudo swapoff -a


# k8s 1.27


# apt-transport-https may be a dummy package; if so, you can skip that package


#########

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


########################

# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


# sudo apt update 

# sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1


# k8s 1.2ww

# sudo apt-get update

# sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


# sudo apt update
# sudo apt install -y kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl



############################################################


### Pod Network

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# =================================   PORT   ====================================



sudo ufw enable
sudo ufw status

#####################################################################