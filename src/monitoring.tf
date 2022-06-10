# https://docs.aws.amazon.com/msk/latest/developerguide/bestpractices.html

# TODO: move this to using our aws-cloudwatch-alarm module below, not positive why its not today.
locals {
  enable_alarms = lookup(var.md_metadata.observability.alarm_channels, "aws", null) != null
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count               = local.enable_alarms ? 1 : 0
  depends_on          = [aws_msk_cluster.main]
  alarm_name          = "MSK high CPU usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "60"
  alarm_description = jsonencode({
    name_prefix = var.md_metadata.name_prefix
    message     = "Total CPU consumption of MSK cluster ${aws_msk_cluster.main.cluster_name} is above 60%. If auto-scaling is not enabled increase your instance size or number of nodes."
  })
  actions_enabled = "true"
  alarm_actions   = [var.md_metadata.observability.alarm_channels.aws.arn]
  ok_actions      = [var.md_metadata.observability.alarm_channels.aws.arn]

  metric_query {
    id          = "m3"
    expression  = "m1 + m2"
    label       = "Total CPU Consumption"
    return_data = true
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "CpuUser"
      namespace   = "AWS/Kafka"
      period      = "120"
      stat        = "Sum"

      dimensions = {
        ClusterName = var.md_metadata.name_prefix
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "CpuSystem"
      namespace   = "AWS/Kafka"
      period      = "120"
      stat        = "Sum"

      dimensions = {
        ClusterName = aws_msk_cluster.main.cluster_name
      }
    }
  }
}

module "storage_capacity_alarm" {
  source = "github.com/massdriver-cloud/terraform-modules//aws-cloudwatch-alarm?ref=b91993f"

  depends_on = [aws_msk_cluster.main]

  md_metadata         = var.md_metadata
  message             = "Total disk usage of AWS MSK cluster ${aws_msk_cluster.main.cluster_name} has reached 85% capacity. Increase the volume size to prevent data loss."
  alarm_name          = "${aws_msk_cluster.main.cluster_name}-lowStorageCapacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "KafkaDataLogsDiskUsed"
  namespace           = "AWS/Kafka"
  period              = "120"
  statistic           = "Sum"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_msk_cluster.main.cluster_name
  }
}
