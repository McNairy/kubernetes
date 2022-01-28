By default when kubernetes creates a service it assigns it a cluster IP by not an external IP, so the service is not accessible from the LAN.
MetalLB will assign a service with a spec.type of LoadBalancer an IP address on the LAN from a range specified in the configuration. Don't forget to open up service on firewall if you can't access the service.

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

Create the metallb-system namespace and install helm chart.

```
$ kubectl create namespace metallb-system
$ helm install metallb bitnami/metallb -n metallb-system -f values.yaml
```

That's it. Now a service with a spec.type of LoadBalancer will automatically be assigned an IP from the default address pool.

For example. In the values.yaml file for the kafka chart I changed the type from ClusterIP to LoadBalancer and upgraded the release. When the kafka servie was back up it had an  external IP. I was then able to telnet to that service to confirm access. I tried this with test nginx pod and it worked as well. 

```
$ kubectl get svc -n kafka
NAME                       TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                      AGE
kafka                      LoadBalancer   10.101.111.119   192.168.1.200   9092:32113/TCP               7h34m
```

```
## Service parameters
##
service:
  ## @param service.type Kubernetes Service type
  ##
  type: LoadBalancer
```

*Resources*
* [MetalLB Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/metallb/)
* [MetalLB Docs](https://metallb.universe.tf/)
