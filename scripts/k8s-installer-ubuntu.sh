#!/bin/bash

VERSION=1.23.1-00

#Install and configure containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Network settings needed for k8s
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Network settings take effect immediately
sudo sysctl --system

# Install containerd
sudo apt-get update && sudo apt-get install -y containerd

# Create a directory for a default containerd configuration file
sudo mkdir -p /etc/containerd

# Generate a default containerd config file
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd so config file takes effect
sudo systemctl restart containerd

# Turn off swap, k8s doesn't like it
sudo swapoff -a

# Persists disable swap
sudo sed -i '/swap/ s/^\(.*\)$/#\1/g' /etc/fstab

# Required packages
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Add gpg key for k8s repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add k8s package repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update packages
sudo apt-get update

# Install kubernetes
sudo apt-get install -y kubelet=$VERSION kubeadm=$VERSION kubectl=$VERSION

# Prevent k8s packages from being automatically updated
sudo apt-mark hold kubelet kubeadm kubectl

# Needed for OpenEBS
sudo systemctl enable iscsid --now
