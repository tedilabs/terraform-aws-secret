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
# Customer Managed Key in KMS
###################################################

# INFO: Use a separate resource
# - 'policy'
# - 'bypass_policy_lockout_safety_check'
resource "aws_kms_replica_key" "this" {
  region = var.region

  primary_key_arn         = var.primary_key
  description             = var.description
  enabled                 = var.enabled
  deletion_window_in_days = var.deletion_window_in_days

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Aliases for Customer Managed Key
###################################################

# Provides an alias for a KMS customer master key.
# AWS Console enforces 1-to-1 mapping between aliases & keys,
# but API allows you to create as many aliases as the account limits.
# INFO: Not supported attributes:
# - `name_prefix`
resource "aws_kms_alias" "this" {
  for_each = var.aliases

  region = var.region

  target_key_id = aws_kms_replica_key.this.key_id
  name          = each.key
}
