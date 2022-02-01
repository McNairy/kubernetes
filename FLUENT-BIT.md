Fluent Bit is a log processor. I set this up to ship all of kubernetes logs to Apache Kafka.

```
mkdir ~/helm/fluent-bit
cd ~/helm/fluent-bit
curl https://raw.githubusercontent.com/fluent/helm-charts/main/charts/fluent-bit/values.yaml -o values.yaml.default #this allows for diffing changes for troubleshooting
```

Update the values.yaml.

Change "multiline.parser docker, cri" to "Parser cri"


Append this to the inputs section.

     [INPUT]
         Name cpu

Appends this to the outputs section.

     [OUTPUT]
         Name    kafka
         Match   *
         Brokers kafka.logging.svc.cluster.local:9092
         Topics  kubernetes
```

Create the fluent-bit namespace and install helm chart.

```
kubectl create namespace fluent-bit
helm install fluent-bit fluent/fluent-bit -n fluent-bit -f values.yaml
```

You can test this is working by logging into the kafka server and using the kafka-console-consumer and viewing the test topic.
There will be a steady stream of data if it is working correctly.

*Resources*
[Installing Fluent Bit with Helm Chart](https://docs.fluentbit.io/manual/installation/kubernetes#installing-with-helm-chart)
[Configure fluent-bit to ship logs to kafka](https://docs.fluentbit.io/manual/pipeline/outputs/kafka)

