# #!/bin/bash

# # Reset Kubernetes on both control-plane and node
# sudo kubeadm reset -f

# # Remove Docker images
# sudo docker rmi -f $(sudo docker images -aq)


# # Remove Docker and Kubernetes packages
# sudo apt purge -y docker.io kubeadm kubectl kubelet kubernetes-cni
# sudo apt autoremove -y
# sudo rm -rf /etc/kubernetes /var/lib/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico

# # Reset ufw (firewall)
# sudo ufw disable
# sudo ufw reset


# # Remove Weave networking (if applied)
# kubectl delete -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# # Remove Kubernetes GPG key and repository
# sudo rm /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg
# sudo rm /etc/apt/sources.list.d/kubernetes.list

# # Remove kubeconfig
# rm -rf $HOME/.kube

# # Disable & Uninstall UFW
# sudo ufw disable
# sudo apt-get remove ufw

# # Remove ufw dir - for Port
# sudo rm -rf /etc/ufw

# echo "Kubernetes uninstallation complete."


##############################

# #!/bin/bash

# # Stop and disable the kubelet service
# sudo systemctl stop kubelet
# sudo systemctl disable kubelet

# # Uninstall the Kubernetes packages
# sudo apt autoremove kubeadm kubectl kubelet -y --allow-change-held-packages

# # Remove the Kubernetes apt repository configuration
# sudo rm /etc/apt/sources.list.d/kubernetes.list

# # Remove the Kubernetes GPG key
# sudo rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# # Unmark hold on the packages
# sudo apt-mark unhold kubelet kubeadm kubectl

# rm -rf $HOME/.kube

# # Clean up any unused packages
# sudo apt-get autoremove -y




# # Optionally, remove Docker if it was installed by the script
# if dpkg -l docker.io | grep -q installed; then
#   sudo apt-get remove -y docker.io
#   sudo systemctl disable --now docker
# fi


# sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml
# sudo rm /etc/kubernetes/manifests/kube-controller-manager.yaml
# sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml
# sudo rm /etc/kubernetes/manifests/etcd.yaml

# sudo rm -rf /var/lib/etcd



#!/bin/bash

# Stop and uninstall Kubernetes components
sudo kubeadm reset -f

# Remove Kubernetes related directories
sudo rm -rf /etc/kubernetes
sudo rm -rf /var/lib/etcd
sudo rm -rf $HOME/.kube

# Uninstall kubeadm, kubelet, and kubectl
sudo apt purge -y kubelet kubeadm kubectl
sudo apt autoremove -y

# Remove Docker
sudo systemctl disable --now docker
sudo apt purge -y docker.io

# Remove Kubernetes repository
sudo rm /etc/apt/sources.list.d/kubernetes.list
sudo rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg

sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml
sudo rm /etc/kubernetes/manifests/kube-controller-manager.yaml
sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml
sudo rm /etc/kubernetes/manifests/etcd.yaml

sudo rm -rf /var/lib/etcd


echo "Kubernetes uninstalled successfully."
