Hypervisor: KVM

Three virtual machines
* k8s-control
* k8s-worker1
* k8s-woker2

Provisioning
* Ubuntu 20.04
* 8G RAM
* 10G Storage 

Networking
* Used cockpit to create a second bridge (bridge0 other than default bridge created by KVM which is a NATed network) that routes directly to the local lan so VMs have direct access to internet. This required a second ethernet port.
* Hardcoded MAC address for each VM in the bridge0 options on the VM
* Added MAC address for each VM into DHCP on my local router for static IP addresses

Gold Image
I manually created a vm and installed the kubernetes components on it.
I added a kube_user for administration and an ssh keypair for remote login authentication

Deployment (in this order)
* Created each vm by cloning the gold image
* Updated the MAC address in the bridge0 networking component
* Change the hostname via the hostname command AND in /etc/hostname BEFORE creating the next image.
* On the control plane I initialized the cluster and added calico networking component
* On the workers I joined the cluster

Post Deployment
* Installed kubectl on non-cluster server (NSC)
* Copied /home/kube_user/.kube/config to NSC:/home/<user>/.kube/config
* Installed helm
* Installed OpenEBS (see STORAGE.md for details)
* Added helm repos for bitnami
* Installed kubeapps via helm

Resources
* [Kubeapps](https://github.com/kubeapps/kubeapps/blob/master/docs/user/getting-started.md)
* [Helm](https://helm.sh/docs/intro/quickstart/)

