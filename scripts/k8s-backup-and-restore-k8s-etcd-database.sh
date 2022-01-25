#!/bin/bash

#
# Backup and restore k8s Etcd database
#

ETCDCTL_API=3
IP=10.0.1.101
USER=cloud_user

# Get cluster name to verify etcdctl utility is functioning correctly
sudo etcdctl get cluster.name \
  --endpoints=https://$IP:2379 \
  --cacert=/home/$USER/etcd-certs/etcd-ca.pem \
  --cert=/home/$USER/etcd-certs/etcd-server.crt \
  --key=/home/$USER/etcd-certs/etcd-server.key

# Save snapshot of etcd database
sudo etcdctl snapshot save /home/$USER/etcd_backup.db \
  --endpoints=https://$IP:2379 \
  --cacert=/home/$USER/etcd-certs/etcd-ca.pem \
  --cert=/home/$USER/etcd-certs/etcd-server.crt \
  --key=/home/$USER/etcd-certs/etcd-server.key

# Stop the etcd service
sudo systemctl stop etcd
# Delete the etcd directory
sudo rm -fr /var/lib/etcd

# Restore the etcd database from a snapshot
sudo etcdctl snapshot restore /home/$USER/etcd_backup.db \
  --initial-cluster etcd-restore=https://$IP:2380 \
  --initial-advertise-peer-urls https://$IP:2380 \
  --name etcd-restore \
  --data-dir /var/lib/etcd

# Change owernship of files to service can start
sudo chown -R etcd:etcd /var/lib/etcd

# Start etcd service
sudo systemctl start etcd

# Get cluster name to verify database restore was successful
sudo etcdctl get cluster.name \
  --endpoints=https://$IP:2379 \
  --cacert=/home/$USER/etcd-certs/etcd-ca.pem \
  --cert=/home/$USER/etcd-certs/etcd-server.crt \
  --key=/home/$USER/etcd-certs/etcd-server.key
