resource "massdriver_artifact" "authentication" {
  field                = "authentication"
  provider_resource_id = aws_msk_cluster.main.arn
  name                 = "AWS Managed Service for Kafka: ${aws_msk_cluster.main.cluster_name}"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          arn = aws_msk_cluster.main.arn
        }
        authentication = {
          zookeeper_connection_string = aws_msk_cluster.main.zookeeper_connect_string_tls
          brokers_connection_string   = aws_msk_cluster.main.bootstrap_brokers_tls
        }
        security = {}
      }
      specs = {
        kafka = {
          version = aws_msk_cluster.main.kafka_version
        }
      }
    }
  )
}
