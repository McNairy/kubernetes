#!/bin/bash

# Prereqs
#sudo apt-get update
#sudo apt-get install open-iscsi
#sudo systemctl enable --now iscsid
#systemctl status iscsid

kubectl create ns openebs
helm repo add openebs https://openebs.github.io/charts
helm repo update
helm install --namespace openebs openebs openebs/openebs


