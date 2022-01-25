#!/bin/bash

kubectl create ns openebs
helm repo add openebs https://openebs.github.io/charts
helm repo update
helm install --namespace openebs openebs openebs/openebs
