#!/bin/bash

VERSION=1.25.2
NETWORK=10.10.0.0/16

# Initialize k8s control plane
sudo kubeadm init --pod-network-cidr $NETWORK --kubernetes-version $VERSION

# Add config for current user so they can use the cluster
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install the Calico Network Add-On
# This could be flannel or any valid k8s network component
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calico.yaml
