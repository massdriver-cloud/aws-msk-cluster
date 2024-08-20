## AWS Managed Streaming for Apache Kafka (AWS MSK)

AWS Managed Streaming for Apache Kafka (MSK) is a fully managed service that makes it easy to build and run applications that use Apache Kafka to process streaming data. With MSK, you can create and manage scalable and secure Kafka clusters with integrated monitoring and security capabilities.

### Design Decisions

- **High Availability**: The MSK cluster is configured across multiple Availability Zones to ensure high availability and fault tolerance.
- **Security**: Security groups are set up to regulate inbound and outbound traffic, ensuring that only permitted traffic can access the Kafka cluster and ZooKeeper instances.
- **Encryption**: Data in transit between the Kafka clients and brokers, as well as within the Kafka cluster and ZooKeeper nodes, is encrypted using TLS.
- **Logging**: Configurable logging options to CloudWatch and S3 are available to enable monitoring and auditing.
- **Monitoring**: Alarms for high CPU usage and storage capacity are set up to alert administrators about potential issues before they become critical.

### Runbook

#### Cannot Connect to Kafka Brokers

To troubleshoot connection issues to the Kafka brokers, you can use the following AWS CLI command to describe the MSK cluster and ensure that the broker endpoints are correct.

```sh
aws msk describe-cluster --cluster-arn <your-msk-cluster-arn>
```

Expect the output to include broker connectivity details like `BootstrapBrokerStringTls` and the list of broker nodes.

#### High CPU Usage on Kafka Brokers

If you receive an alert for high CPU usage, you can use CloudWatch to check CPU metrics:

```sh
aws cloudwatch get-metric-statistics --namespace AWS/Kafka --metric-name CpuUser --dimensions Name=ClusterName,Value=<your-cluster-name> --start-time 2023-01-01T23:18:00 --end-time 2023-01-01T23:30:00 --period 60 --statistics Average
```

Analyze the returned data points to determine the average CPU usage.

#### Storage Capacity Alarm

If the storage capacity of your Kafka brokers hits a critical level, you need to analyze the disk usage:

```sh
aws cloudwatch get-metric-statistics --namespace AWS/Kafka --metric-name KafkaDataLogsDiskUsed --dimensions Name=ClusterName,Value=<your-cluster-name> --start-time 2023-01-01T00:00:00 --end-time 2023-01-01T23:59:00 --period 86400 --statistics Sum
```

Check the disk usage statistics and make necessary adjustments to the storage capacity if required.

#### ZooKeeper Connection Issues

If you face issues connecting to ZooKeeper nodes, you can use the following commands to troubleshoot:

1. **List ZooKeeper Nodes**

    ```sh
    aws msk describe-cluster --cluster-arn <your-msk-cluster-arn>
    ```

2. **Check ZooKeeper Status**

    Connect to the ZooKeeper node and check its status:
    
    ```sh
    echo "ruok" | nc <zookeeper-node-endpoint> 2182
    ```

    The expected response is `imok`.

#### Reset Kafka Offset

If you need to reset the Kafka offset for a consumer group, use the following `kafka-consumer-groups.sh` command (part of Kafka binaries):

```sh
kafka-consumer-groups.sh --bootstrap-server <broker-endpoint> --group <consumer-group> --reset-offsets --to-earliest --execute --topic <topic-name>
```

Ensure the offsets are reset to the desired position.

#### Monitor and Debug Kafka Topics

To describe Kafka topics and monitor their partitions and offsets:

```sh
kafka-topics.sh --describe --bootstrap-server <broker-endpoint> --topic <topic-name>
```

This command provides information about the number of partitions, replicas, and offsets, helping you debug any topic-related issues.

