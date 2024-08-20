## AWS Managed Service for Kafka

AWS Managed Service for Kafka (MSK) is a fully managed service that makes it easy for you to build and run applications that use Apache Kafka to process streaming data. With MSK, you can create and manage highly available and scalable Kafka clusters, back up your data, and perform monitoring and alerting with minimal effort.

### Design Decisions

1. **Security Groups**: Separate internal and external security groups are configured to manage access control. Internal security handles inter-nodal communication, while the external group controls ingress from the assigned VPC.

2. **Subnets Allocation**: Subnets are dynamically allocated based on internal subnets information, ensuring optimal distribution across Availability Zones.

3. **Kafka Configuration**: Configurations are version-controlled and updated with minimal downtime using the `create_before_destroy` lifecycle rule.

4. **Logging**: Conditional configuration for logging, supporting either CloudWatch or S3-based logging.

5. **Monitoring**: Alarms are set up for high CPU usage and storage capacity, integrated with a predefined alarm channel for notifications.

### Runbook

#### Kafka Broker Connection Issues

Troubleshoot connectivity issues with your Kafka brokers using AWS CLI commands.

```sh
# Check broker connection status
aws kafka describe-cluster --cluster-arn <your-cluster-arn> --query 'ClusterInfo.BrokerNodeGroupInfo'
```

This command provides information about your broker nodes, including their status and connectivity details.

#### High CPU Usage

If you receive an alert for high CPU usage, check the CloudWatch metrics for detailed analysis.

```sh
# Retrieve CPU metrics
aws cloudwatch get-metric-statistics --namespace AWS/Kafka --metric-name CpuUser --dimensions Name=ClusterName,Value=<your-cluster-name> --start-time 2023-10-01T00:00:00Z --end-time 2023-10-01T23:59:59Z --period 300 --statistics Average
```

This command fetches the average CPU usage for the specified time period, helping you identify any spikes or anomalies.

#### ZooKeeper Connection Issues

Troubleshoot ZooKeeper connectivity using the connection string and Zookeeper CLI.

```sh
# Check ZooKeeper status
zookeeper-shell <zookeeper_connection_string> status
```

This command gives you the current status of the ZooKeeper instance, indicating if there’s an issue with the cluster coordination.

#### Storage Issues

Check if the storage is nearing capacity using AWS CLI commands.

```sh
# Retrieve storage metrics
aws cloudwatch get-metric-statistics --namespace AWS/Kafka --metric-name KafkaDataLogsDiskUsed --dimensions Name=ClusterName,Value=<your-cluster-name> --start-time 2023-10-01T00:00:00Z --end-time 2023-10-01T23:59:59Z --period 300 --statistics Sum
```

This command helps you understand how much disk space is being used, so you can take action before running out of storage. 

#### Retrying Failed Nodes

If a broker node fails, you can attempt to restart it.

```sh
# Restart broker node
aws kafka reboot-broker --cluster-arn <your-cluster-arn> --broker-id <broker-id>
```

This command reboots the specified broker node, which may resolve issues related to temporary faults or misconfigurations.

#### Connectivity Test

Check the network connectivity to the Kafka broker as a validation step.

```sh
# Network connectivity test
nc -zv <broker_connection_string> 9094
```

This command verifies the ability to connect to the broker node on the specified port, ensuring that network configurations are correct.

