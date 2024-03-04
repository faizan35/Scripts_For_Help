#!/bin/bash

sudo apt-get update

sudo swapoff -a
sudo apt install docker.io -y

sudo systemctl enable --now docker

# Install k8s

# sudo apt-get install -y apt-transport-https ca-certificates curl

# curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg


# echo 'deb https://packages.cloud.google.com/apt kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# sudo apt update
# sudo apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y

##########################


# Kubernetes 1.29

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




# =================================   PORT   ====================================

# install ufw
sudo apt-get install ufw

# Create rule files
sudo touch /etc/ufw/before.rules
sudo touch /etc/ufw/after.rules
sudo touch /etc/ufw/user.rules
sudo touch /etc/ufw/before6.rules
sudo touch /etc/ufw/after6.rules
sudo touch /etc/ufw/user6.rules

# ----------------------- before.rules ------------------------
echo "#
# rules.before
#
# Rules that should be run before the ufw command line added rules. Custom
# rules should be added to one of these chains:
#   ufw-before-input
#   ufw-before-output
#   ufw-before-forward
#

# Don't delete these required lines, otherwise there will be errors
*filter
:ufw-before-input - [0:0]
:ufw-before-output - [0:0]
:ufw-before-forward - [0:0]
:ufw-not-local - [0:0]
# End required lines


# allow all on loopback
-A ufw-before-input -i lo -j ACCEPT
-A ufw-before-output -o lo -j ACCEPT

# quickly process packets for which we already have a connection
-A ufw-before-input -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ufw-before-output -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ufw-before-forward -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# drop INVALID packets (logs these in loglevel medium and higher)
-A ufw-before-input -m conntrack --ctstate INVALID -j ufw-logging-deny
-A ufw-before-input -m conntrack --ctstate INVALID -j DROP

# ok icmp codes for INPUT
-A ufw-before-input -p icmp --icmp-type destination-unreachable -j ACCEPT
-A ufw-before-input -p icmp --icmp-type time-exceeded -j ACCEPT
-A ufw-before-input -p icmp --icmp-type parameter-problem -j ACCEPT
-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT

# ok icmp code for FORWARD
-A ufw-before-forward -p icmp --icmp-type destination-unreachable -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type time-exceeded -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type parameter-problem -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type echo-request -j ACCEPT

# allow dhcp client to work
-A ufw-before-input -p udp --sport 67 --dport 68 -j ACCEPT

#
# ufw-not-local
#
-A ufw-before-input -j ufw-not-local

# if LOCAL, RETURN
-A ufw-not-local -m addrtype --dst-type LOCAL -j RETURN

# if MULTICAST, RETURN
-A ufw-not-local -m addrtype --dst-type MULTICAST -j RETURN

# if BROADCAST, RETURN
-A ufw-not-local -m addrtype --dst-type BROADCAST -j RETURN

# all other non-local packets are dropped
-A ufw-not-local -m limit --limit 3/min --limit-burst 10 -j ufw-logging-deny
-A ufw-not-local -j DROP

# allow MULTICAST mDNS for service discovery (be sure the MULTICAST line above
# is uncommented)
-A ufw-before-input -p udp -d 224.0.0.251 --dport 5353 -j ACCEPT

# allow MULTICAST UPnP for service discovery (be sure the MULTICAST line above
# is uncommented)
-A ufw-before-input -p udp -d 239.255.255.250 --dport 1900 -j ACCEPT

# don't delete the 'COMMIT' line or these rules won't be processed
COMMIT" | sudo tee /etc/ufw/before.rules

# ----------------------------------------------------------------------

# ----------------------- after.rules ------------------------
echo "#
# rules.input-after
#
# Rules that should be run after the ufw command line added rules. Custom
# rules should be added to one of these chains:
#   ufw-after-input
#   ufw-after-output
#   ufw-after-forward
#

# Don't delete these required lines, otherwise there will be errors
*filter
:ufw-after-input - [0:0]
:ufw-after-output - [0:0]
:ufw-after-forward - [0:0]
# End required lines

# don't log noisy services by default
-A ufw-after-input -p udp --dport 137 -j ufw-skip-to-policy-input
-A ufw-after-input -p udp --dport 138 -j ufw-skip-to-policy-input
-A ufw-after-input -p tcp --dport 139 -j ufw-skip-to-policy-input
-A ufw-after-input -p tcp --dport 445 -j ufw-skip-to-policy-input
-A ufw-after-input -p udp --dport 67 -j ufw-skip-to-policy-input
-A ufw-after-input -p udp --dport 68 -j ufw-skip-to-policy-input

# don't log noisy broadcast
-A ufw-after-input -m addrtype --dst-type BROADCAST -j ufw-skip-to-policy-input

# don't delete the 'COMMIT' line or these rules won't be processed
COMMIT" | sudo tee /etc/ufw/after.rules
# -----------------------------------------------------------


# ----------------------- before6.rules ------------------------
echo "#
# rules.before
#
# Rules that should be run before the ufw command line added rules. Custom
# rules should be added to one of these chains:
#   ufw6-before-input
#   ufw6-before-output
#   ufw6-before-forward
#

# Don't delete these required lines, otherwise there will be errors
*filter
:ufw6-before-input - [0:0]
:ufw6-before-output - [0:0]
:ufw6-before-forward - [0:0]
# End required lines


# allow all on loopback
-A ufw6-before-input -i lo -j ACCEPT
-A ufw6-before-output -o lo -j ACCEPT

# drop packets with RH0 headers
-A ufw6-before-input -m rt --rt-type 0 -j DROP
-A ufw6-before-forward -m rt --rt-type 0 -j DROP
-A ufw6-before-output -m rt --rt-type 0 -j DROP

# quickly process packets for which we already have a connection
-A ufw6-before-input -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ufw6-before-output -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A ufw6-before-forward -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# multicast ping replies are part of the ok icmp codes for INPUT (rfc4890,
# 4.4.1 and 4.4.2), but don't have an associated connection and are otherwise
# be marked INVALID, so allow here instead.
-A ufw6-before-input -p icmpv6 --icmpv6-type echo-reply -j ACCEPT

# drop INVALID packets (logs these in loglevel medium and higher)
-A ufw6-before-input -m conntrack --ctstate INVALID -j ufw6-logging-deny
-A ufw6-before-input -m conntrack --ctstate INVALID -j DROP

# ok icmp codes for INPUT (rfc4890, 4.4.1 and 4.4.2)
-A ufw6-before-input -p icmpv6 --icmpv6-type destination-unreachable -j ACCEPT
-A ufw6-before-input -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT
# codes 0 and 1
-A ufw6-before-input -p icmpv6 --icmpv6-type time-exceeded -j ACCEPT
# codes 0-2 (echo-reply needs to be before INVALID, see above)
-A ufw6-before-input -p icmpv6 --icmpv6-type parameter-problem -j ACCEPT
-A ufw6-before-input -p icmpv6 --icmpv6-type echo-request -j ACCEPT
-A ufw6-before-input -p icmpv6 --icmpv6-type router-solicitation -m hl --hl-eq 255 -j ACCEPT
-A ufw6-before-input -p icmpv6 --icmpv6-type router-advertisement -m hl --hl-eq 255 -j ACCEPT
-A ufw6-before-input -p icmpv6 --icmpv6-type neighbor-solicitation -m hl --hl-eq 255 -j ACCEPT
-A ufw6-before-input -p icmpv6 --icmpv6-type neighbor-advertisement -m hl --hl-eq 255 -j ACCEPT
# IND solicitation
-A ufw6-before-input -p icmpv6 --icmpv6-type 141 -m hl --hl-eq 255 -j ACCEPT
# IND advertisement
-A ufw6-before-input -p icmpv6 --icmpv6-type 142 -m hl --hl-eq 255 -j ACCEPT
# MLD query
-A ufw6-before-input -p icmpv6 --icmpv6-type 130 -s fe80::/10 -j ACCEPT
# MLD report
-A ufw6-before-input -p icmpv6 --icmpv6-type 131 -s fe80::/10 -j ACCEPT
# MLD done
-A ufw6-before-input -p icmpv6 --icmpv6-type 132 -s fe80::/10 -j ACCEPT
# MLD report v2
-A ufw6-before-input -p icmpv6 --icmpv6-type 143 -s fe80::/10 -j ACCEPT
# SEND certificate path solicitation
-A ufw6-before-input -p icmpv6 --icmpv6-type 148 -m hl --hl-eq 255 -j ACCEPT
# SEND certificate path advertisement
-A ufw6-before-input -p icmpv6 --icmpv6-type 149 -m hl --hl-eq 255 -j ACCEPT
# MR advertisement
-A ufw6-before-input -p icmpv6 --icmpv6-type 151 -s fe80::/10 -m hl --hl-eq 1 -j ACCEPT
# MR solicitation
-A ufw6-before-input -p icmpv6 --icmpv6-type 152 -s fe80::/10 -m hl --hl-eq 1 -j ACCEPT
# MR termination
-A ufw6-before-input -p icmpv6 --icmpv6-type 153 -s fe80::/10 -m hl --hl-eq 1 -j ACCEPT

# ok icmp codes for OUTPUT (rfc4890, 4.4.1 and 4.4.2)
-A ufw6-before-output -p icmpv6 --icmpv6-type destination-unreachable -j ACCEPT
-A ufw6-before-output -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT
# codes 0 and 1
-A ufw6-before-output -p icmpv6 --icmpv6-type time-exceeded -j ACCEPT
# codes 0-2
-A ufw6-before-output -p icmpv6 --icmpv6-type parameter-problem -j ACCEPT
-A ufw6-before-output -p icmpv6 --icmpv6-type echo-request -j ACCEPT
-A ufw6-before-output -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
-A ufw6-before-output -p icmpv6 --icmpv6-type router-solicitation -m hl --hl-eq 255 -j ACCEPT
-A ufw6-before-output -p icmpv6 --icmpv6-type neighbor-advertisement -m hl --hl-eq 255 -j ACCEPT
-A ufw6-before-output -p icmpv6 --icmpv6-type neighbor-solicitation -m hl --hl-eq 255 -j ACCEPT
-A ufw6-before-output -p icmpv6 --icmpv6-type router-advertisement -m hl --hl-eq 255 -j ACCEPT
# IND solicitation
-A ufw6-before-output -p icmpv6 --icmpv6-type 141 -m hl --hl-eq 255 -j ACCEPT
# IND advertisement
-A ufw6-before-output -p icmpv6 --icmpv6-type 142 -m hl --hl-eq 255 -j ACCEPT
# MLD query
-A ufw6-before-output -p icmpv6 --icmpv6-type 130 -s fe80::/10 -j ACCEPT
# MLD report
-A ufw6-before-output -p icmpv6 --icmpv6-type 131 -s fe80::/10 -j ACCEPT
# MLD done
-A ufw6-before-output -p icmpv6 --icmpv6-type 132 -s fe80::/10 -j ACCEPT
# MLD report v2
-A ufw6-before-output -p icmpv6 --icmpv6-type 143 -s fe80::/10 -j ACCEPT
# SEND certificate path solicitation
-A ufw6-before-output -p icmpv6 --icmpv6-type 148 -m hl --hl-eq 255 -j ACCEPT
# SEND certificate path advertisement
-A ufw6-before-output -p icmpv6 --icmpv6-type 149 -m hl --hl-eq 255 -j ACCEPT
# MR advertisement
-A ufw6-before-output -p icmpv6 --icmpv6-type 151 -s fe80::/10 -m hl --hl-eq 1 -j ACCEPT
# MR solicitation
-A ufw6-before-output -p icmpv6 --icmpv6-type 152 -s fe80::/10 -m hl --hl-eq 1 -j ACCEPT
# MR termination
-A ufw6-before-output -p icmpv6 --icmpv6-type 153 -s fe80::/10 -m hl --hl-eq 1 -j ACCEPT

# ok icmp codes for FORWARD (rfc4890, 4.3.1)
-A ufw6-before-forward -p icmpv6 --icmpv6-type destination-unreachable -j ACCEPT
-A ufw6-before-forward -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT
# codes 0 and 1
-A ufw6-before-forward -p icmpv6 --icmpv6-type time-exceeded -j ACCEPT
# codes 0-2
-A ufw6-before-forward -p icmpv6 --icmpv6-type parameter-problem -j ACCEPT
-A ufw6-before-forward -p icmpv6 --icmpv6-type echo-request -j ACCEPT
-A ufw6-before-forward -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
# ok icmp codes for FORWARD (rfc4890, 4.3.2)
# Home Agent Address Discovery Reques
-A ufw6-before-input -p icmpv6 --icmpv6-type 144 -j ACCEPT
# Home Agent Address Discovery Reply
-A ufw6-before-input -p icmpv6 --icmpv6-type 145 -j ACCEPT
# Mobile Prefix Solicitation
-A ufw6-before-input -p icmpv6 --icmpv6-type 146 -j ACCEPT
# Mobile Prefix Advertisement
-A ufw6-before-input -p icmpv6 --icmpv6-type 147 -j ACCEPT

# allow dhcp client to work
-A ufw6-before-input -p udp -s fe80::/10 --sport 547 -d fe80::/10 --dport 546 -j ACCEPT

# allow MULTICAST mDNS for service discovery
-A ufw6-before-input -p udp -d ff02::fb --dport 5353 -j ACCEPT

# allow MULTICAST UPnP for service discovery
-A ufw6-before-input -p udp -d ff02::f --dport 1900 -j ACCEPT

# don't delete the 'COMMIT' line or these rules won't be processed
COMMIT" | sudo tee /etc/ufw/before6.rules
# -----------------------------------------------------------

# ----------------------- after6.rules ------------------------
echo "#
# rules.input-after
#
# Rules that should be run after the ufw command line added rules. Custom
# rules should be added to one of these chains:
#   ufw6-after-input
#   ufw6-after-output
#   ufw6-after-forward
#

# Don't delete these required lines, otherwise there will be errors
*filter
:ufw6-after-input - [0:0]
:ufw6-after-output - [0:0]
:ufw6-after-forward - [0:0]
# End required lines

# don't log noisy services by default
-A ufw6-after-input -p udp --dport 137 -j ufw6-skip-to-policy-input
-A ufw6-after-input -p udp --dport 138 -j ufw6-skip-to-policy-input
-A ufw6-after-input -p tcp --dport 139 -j ufw6-skip-to-policy-input
-A ufw6-after-input -p tcp --dport 445 -j ufw6-skip-to-policy-input
-A ufw6-after-input -p udp --dport 546 -j ufw6-skip-to-policy-input
-A ufw6-after-input -p udp --dport 547 -j ufw6-skip-to-policy-input

# don't delete the 'COMMIT' line or these rules won't be processed
COMMIT" | sudo tee /etc/ufw/after6.rules
# -----------------------------------------------------------

# Allow ssh 
sudo ufw allow ssh

sudo ufw enable
sudo ufw status

#####################################################################
