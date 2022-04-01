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

resource "aws_secretsmanager_secret" "this" {
  name        = var.name
  description = var.description

  # Use `aws_secretsmanager_policy` instead
  policy                         = null
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
      kms_key_id = try(replica.kms_key, null)
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
      ? jsonencode(var.value)
      : (var.type == "TEXT" ? tostring(var.value) : null)
    )
    binary = var.type == "BINARY" ? var.value : null
  }
  versions = [
    for version in var.versions :
    merge(version, {
      id = var.type == "KEY_VALUE" ? md5(jsonencode(version.value)) : md5(version.value)

      value = (var.type == "KEY_VALUE"
        ? jsonencode(version.value)
        : (var.type == "TEXT" ? tostring(version.value) : null)
      )
      binary = var.type == "BINARY" ? version.value : null
    })
  ]
}

resource "aws_secretsmanager_secret_version" "latest" {
  count = var.value != null ? 1 : 0

  secret_id = aws_secretsmanager_secret.this.arn

  secret_string = local.latest.value
  secret_binary = try(tostring(local.latest.binary), null)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "versions" {
  for_each = {
    for version in local.versions :
    version.id => version
  }

  secret_id = aws_secretsmanager_secret.this.arn

  secret_string  = each.value.value
  secret_binary  = try(tostring(each.value.binary), null)
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

  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = var.policy

  block_public_policy = var.block_public_policy
}


###################################################
# Configuration of Secret Rotation
###################################################

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.rotation_lambda_function != null ? 1 : 0

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_function

  rotation_rules {
    automatically_after_days = var.rotation_duration_in_days
  }
}
