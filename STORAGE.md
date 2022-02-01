**Installed OpenEBS for local storage usage.**

[OpenEBS](https://openebs.io/docs/user-guides/localpv-hostpath#create-a-persistentvolumeclaim)
[Deploy and Use OpenEBS Container Storage on Kubernetes](https://computingforgeeks.com/deploy-and-use-openebs-container-storage-on-kubernetes/)
Dynamic Provisioning so I don't have create PVC definitions for each app I install.

* [Dynamic Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/)
* [Dynamic Kubernetes Local Persistent Volumes](https://github.com/openebs/dynamic-localpv-provisioner)

Marked openebs-hostpath as default storage class
* [Persistent Storage Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* [Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)
The key part here was that in order to enable a default storage class an admission controller is needed. Per this documentation, the DefaultStorageClass admission plugin is enabled by default.

This was actually quite confusing because the documentation says to run the <code>kube-apiserver</code> command. That command does not exist on the control plane. It only exists on the container that is running the kube apiserver. So, I had to look at the pods and get the one whose name started with kube-apiserver and exec the command on that.

<code>kubectl exec kube-apiserver-k8s-control -n kube-system -- kube-apiserver -h | grep enable-admission-plugins</code>

**Installed NFS for network storage**

My hard drive crashed after I got kubernetes logging to kafka. I suspect it was just too much running three VMs and logging all of kubernetes logs to that same server. So setup an NFS server and dynamic provisioning. After getting that done then I just use the nfs-client storage class to create volumes on the NFS server.


* [Change Default Storage Class](https://kubernetes.io/docs/tasks/administer-cluster/change-default-storage-class/)
kubectl patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

Resources
* [Understand Volume Provisioning in kubernetes using PVs and PVCs](https://medium.com/@dunefro/part-1-4-container-attached-storage-with-openebs-understand-volume-provisioning-in-kubernetes-e7d7497dfe7f)
* [How to access kube-apiserver on command line?](https://stackoverflow.com/questions/56542351/how-to-access-kube-apiserver-on-command-line)
* [How to setup an NFS server](https://learn.acloud.guru/handson/afe186bc-c296-4465-b222-a31e1a861292)
* [Kubernetes NFS Subdir External Provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)
* [A guide to setting up dynamic NFS provisioning in Kubernetes](https://www.youtube.com/watch?v=DF3v2P8ENEg)
