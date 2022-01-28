This is a test proof-of-concept kafka setup so I kept the minumum of 1 broker, 1 partion per topic, and 1 replication.

```
mkdir ~/helm/bitnami/kafka
cd ~/helm/bitnami/kafka
curl https://raw.githubusercontent.com/bitnami/charts/master/bitnami/kafka/values.yaml -o values.yaml.default #this allows for diffing changes for troubleshooting
```

Updated parameters in the values.yaml file.

```
$ diff values.yaml values.yaml.default
138c138
< deleteTopicEnable: true
---
> deleteTopicEnable: false
615c615
<   type: LoadBalancer
---
>   type: ClusterIP
```

I allow the deletion of topics because this is a lab setup and I'm learning kafka and want to delete topics once I'm done fiddling with them.
This can be disabled by setting it back to false and upgrading the release.

Create the kafka namespace and install helm chart.

```
kubectl create namespace kafka
helm install kafka bitnami/kafka --namespace kafka -f values.yaml
```

To manage kafka from the command line login to one of the kafka servers and navigate to where the command-line tools are located. For example:

```
kubectl exec --stdin --tty kafka-0 --namespace kafka -- /bin/bash
cd /opt/bitnami/kafka/bin
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test --partions 1 --replication-factor 1
```

*Resources*
* [Bitnami Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/kafka)
