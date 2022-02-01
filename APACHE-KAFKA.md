This is a test proof-of-concept kafka setup so I kept the minumum of 1 broker, 1 partion per topic, and 1 replication.
Note: The first time I got this working about 10 minutes later my secondary hard drive crashed and took my this repo with it. I figured the constant reads and writes from kubernetes on the VMs on the same host killed the drive. Then I installed kafka on an old workstation, but no matter what I did I could connect to it. Instead, I turned that old workstation into an NFS server. I reinstalled kafka in kubernetes but with its volumes as NFS volumes stored on that NSF server.

```
mkdir ~/helm/bitnami/kafka
cd ~/helm/bitnami/kafka
curl https://raw.githubusercontent.com/bitnami/charts/master/bitnami/kafka/values.yaml -o values.yaml.default #this allows for diffing changes for troubleshooting
```

Updated parameters in the values.yaml file.

```
deleteTopicEnable: true
storageClass: nfs-client # There are a few of them, I filled in all of them with "nfs-client"

```

I allow the deletion of topics because this is a lab setup and I'm learning kafka and want to delete topics once I'm done fiddling with them.
This can be disabled by setting it back to false and upgrading the release.

Create the kafka namespace and install helm chart.

```
kubectl create namespace kafka
helm install kafka bitnami/kafka --namespace kafka -f values.yaml
```

To manage kafka from the command line login to one of the kafka servers and navigate to where the command-line tools are located. There is a kafka-client I could install but why waste the resources? For example, I did the following to create the kubernetes topic I ship logs:

```
kubectl exec --stdin --tty kafka-0 --namespace kafka -- /bin/bash
cd /opt/bitnami/kafka/bin
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic kubernetes --partions 1 --replication-factor 1
```

*Resources*
* [Bitnami Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/kafka)
