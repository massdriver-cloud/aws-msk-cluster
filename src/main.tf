locals {
  server_properties = ""
  subnets           = [for subnet in slice(var.vpc.data.infrastructure.internal_subnets, 0, 3) : element(split("/", subnet["arn"]), 1)]
  num_zones         = min(3, length(var.vpc.data.infrastructure.internal_subnets)) # must be 2 or 3
  vpc_id            = element(split("/", var.vpc.data.infrastructure.arn), 1)
}

resource "random_shuffle" "subnets" {
  input        = [for subnet in var.vpc.data.infrastructure.internal_subnets : element(split("/", subnet["arn"]), 1)]
  result_count = local.num_zones

  // reset if the VPC changes
  keepers = {
    "vpc_arn" = var.vpc.data.infrastructure.arn
  }
}

resource "aws_security_group" "internal_security_group" {
  name_prefix = "${var.md_metadata.name_prefix}-internal"
  vpc_id      = local.vpc_id
}

resource "aws_security_group_rule" "internal_kafka_tls" {
  from_port         = 9094
  to_port           = 9094
  protocol          = "tcp"
  security_group_id = aws_security_group.internal_security_group.id
  type              = "ingress"
  self              = true
}

resource "aws_security_group_rule" "internal_zookeeper_tls" {
  from_port         = 2182
  to_port           = 2182
  protocol          = "tcp"
  security_group_id = aws_security_group.internal_security_group.id
  type              = "ingress"
  self              = true
}

resource "aws_security_group" "external_security_group" {
  name_prefix = "${var.md_metadata.name_prefix}-external"
  vpc_id      = local.vpc_id
}

resource "aws_security_group_rule" "external_kafka_tls" {
  count             = true ? 1 : 0
  from_port         = 9094
  to_port           = 9094
  protocol          = "tcp"
  security_group_id = aws_security_group.external_security_group.id
  cidr_blocks       = [var.vpc.data.infrastructure.cidr]
  type              = "ingress"
}

resource "aws_security_group_rule" "external_zookeeper_tls" {
  count             = true ? 1 : 0
  from_port         = 2182
  to_port           = 2182
  protocol          = "tcp"
  security_group_id = aws_security_group.external_security_group.id
  cidr_blocks       = [var.vpc.data.infrastructure.cidr]
  type              = "ingress"
}

resource "random_id" "configuration" {
  prefix      = "${var.md_metadata.name_prefix}-"
  byte_length = 8

  keepers = {
    server_properties = local.server_properties
    kafka_version     = var.kafka_version
  }
}

resource "aws_msk_configuration" "main" {
  kafka_versions    = [random_id.configuration.keepers.kafka_version]
  name              = random_id.configuration.dec
  server_properties = random_id.configuration.keepers.server_properties

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_msk_cluster" "main" {
  depends_on = [aws_msk_configuration.main, random_shuffle.subnets]

  cluster_name           = var.md_metadata.name_prefix
  kafka_version          = var.kafka_version                      # enum
  number_of_broker_nodes = local.num_zones * var.brokers_per_zone # must be a multiple of number of AZs
  enhanced_monitoring    = "PER_BROKER"

  broker_node_group_info {
    client_subnets = random_shuffle.subnets.result # must be 3
    instance_type  = var.instance_type
    security_groups = [
      aws_security_group.internal_security_group.id,
      aws_security_group.external_security_group.id,
    ]
    storage_info {
      ebs_storage_info {
        volume_size = var.volume_size
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.main.arn
    revision = aws_msk_configuration.main.latest_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  logging_info {
    broker_logs {
      dynamic "cloudwatch_logs" {
        for_each = var.logging_method == "cloudwatch" ? ["true"] : []
        content {
          enabled   = true
          log_group = var.md_metadata.name_prefix
        }
      }
      dynamic "s3" {
        for_each = var.logging_method == "s3" ? ["true"] : []
        content {
          enabled = true
          bucket  = "${var.md_metadata.name_prefix}-logs"
          prefix  = "logs"
        }
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "msk_logs" {
  count = var.logging_method == "cloudwatch" ? 1 : 0
  name  = var.md_metadata.name_prefix
}

resource "aws_s3_bucket" "msk_logs_bucket" {
  count  = var.logging_method == "s3" ? 1 : 0
  bucket = "${var.md_metadata.name_prefix}-logs}"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  count  = var.logging_method == "s3" ? 1 : 0
  bucket = aws_s3_bucket.msk_logs_bucket[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "configuration" {
  count  = var.logging_method == "s3" ? 1 : 0
  bucket = aws_s3_bucket.msk_logs_bucket[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}
