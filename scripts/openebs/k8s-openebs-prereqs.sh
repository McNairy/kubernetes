#!/bin/bash

sudo apt-get update
sudo apt-get install open-iscsi
sudo systemctl enable --now iscsid
systemctl status iscsid
sudo mkdir -p /var/openebs/local
