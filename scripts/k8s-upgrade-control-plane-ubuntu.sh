#!/bin/bash

#
# Upgrade k8s components
#

VERSION=1.22.2
PATCH=00
NODE=k8s-control

# Upgrade kubeadm package
sudo apt-get install -y --allow-change-held-packages kubeadm=$VERSION-$PATCH

# Drain node
kubectl drain $NODE --ignore-daemonsets

# Get upgrade plan
sudo kubeadm upgrade plan $VERSION

# Apply kubeadm upgrade
sudo kubeadm upgrade apply $VERSION

# Upgrade kubelet and kubectl packages
sudo apt-get install -y --allow-change-held-packages kubelet=$VERSION-$PATCH kubectl=$VERSION-$PATCH

# Reload services just in case any systemd service files were changed
sudo systemctl daemon-reload

# Restart kubelet
sudo systemctl restart kubelet

# Uncordon control plane so it can be used by k8s scheduler again
sudo kubectl uncordon $NODE
