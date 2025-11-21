locals {
  metadata = {
    package = "terraform-aws-secret"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}


###################################################
# Secrets Manager Secret
###################################################

# INFO: Use a separate resource
# - 'policy'
# INFO: Not supported attributes
# - `name_prefix`
resource "aws_secretsmanager_secret" "this" {
  region = var.region

  name        = var.name
  description = var.description

  kms_key_id                     = var.kms_key
  recovery_window_in_days        = var.deletion_window_in_days
  force_overwrite_replica_secret = var.overwrite_in_replicas

  dynamic "replica" {
    for_each = {
      for replica in var.replicas :
      replica.region => replica
    }

    content {
      region     = replica.key
      kms_key_id = replica.kms_key
    }
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Versions of Secret
###################################################

locals {
  latest = {
    value = (var.type == "KEY_VALUE"
      ? jsonencode(var.kv_value)
      : (var.type == "TEXT" ? var.text_value : null)
    )
    binary = var.type == "BINARY" ? var.binary_value : null
  }
  versions = [
    for version in var.versions :
    merge(version, {
      id = var.type == "KEY_VALUE" ? md5(jsonencode(version.kv_value)) : md5(version.text_value != null ? version.text_value : "")

      value = (var.type == "KEY_VALUE"
        ? jsonencode(version.kv_value)
        : (var.type == "TEXT" ? version.text_value : null)
      )
      binary = var.type == "BINARY" ? version.binary_value : null
    })
  ]
}

resource "aws_secretsmanager_secret_version" "latest" {
  count = anytrue([
    var.binary_value != null,
    var.text_value != null,
    length(var.kv_value) > 0,
  ]) ? 1 : 0

  region = var.region

  secret_id = aws_secretsmanager_secret.this.arn

  secret_string = local.latest.value
  secret_binary = local.latest.binary

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "versions" {
  for_each = {
    for version in local.versions :
    version.id => version
  }

  region = var.region

  secret_id = aws_secretsmanager_secret.this.arn

  secret_string  = each.value.value
  secret_binary  = each.value.binary
  version_stages = each.value.labels

  lifecycle {
    create_before_destroy = true
  }
}


###################################################
# Resource Policy of Secret
###################################################

resource "aws_secretsmanager_secret_policy" "this" {
  count = var.policy != null ? 1 : 0

  region = var.region

  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = var.policy

  block_public_policy = var.block_public_policy
}


###################################################
# Configuration of Secret Rotation
###################################################

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.rotation.enabled ? 1 : 0

  region = var.region

  secret_id = aws_secretsmanager_secret.this.id

  rotate_immediately  = var.rotation.rotate_immediately
  rotation_lambda_arn = var.rotation.lambda_function

  rotation_rules {
    automatically_after_days = var.rotation.schedule_frequency
    schedule_expression      = var.rotation.schedule_expression

    duration = var.rotation.duration != null ? "${var.rotation.duration}h" : null
  }
}
