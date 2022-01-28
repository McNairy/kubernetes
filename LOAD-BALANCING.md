By default when kubernetes creates a service it assigns it a cluster IP by not an external IP, so the service is not accessible from the LAN.
MetalLB will assign a service with spec.type an IP address on the LAN from a range specified in the configuration. Don't forget to open up service on firewall if you can't access the service.

```
$ mkdir ~/helm/bitnami/metallb
$ cd ~/helm/bitnami/metallb
$ curl https://raw.githubusercontent.com/bitnami/charts/master/bitnami/metallb/values.yaml -o values.yaml.default #this allows for diffing changes for troubleshooting
```

Update the values.yaml configInline block to create a default pool of addresses for the loadbalancer to use. For example:

```
configInline:
  address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.1.200-192.168.1.240
```

Create kafka namespace and install helm chart.

```
$ kubectl create namespace kafka
$ helm install kafka bitnami/kafka -n kafka -f values.yaml
```

That's it. Now when a service witt spec.type of LoadBalancer will automatically be assigned and IP from the default address pool.

*Resources*
* [MetalLB Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/metallb/)
* [MetalLB Docs](https://metallb.universe.tf/)
