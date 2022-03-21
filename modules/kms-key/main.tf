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
# KMS Resources
###################################################

resource "aws_kms_key" "this" {
  description = var.description

  key_usage                = var.usage
  customer_master_key_spec = var.spec

  policy                             = var.policy
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check

  deletion_window_in_days = var.deletion_window_in_days

  is_enabled          = var.enabled
  enable_key_rotation = var.key_rotation_enabled
  multi_region        = var.multi_region_enabled

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}

# Provides an alias for a KMS customer master key.
# AWS Console enforces 1-to-1 mapping between aliases & keys,
# but API allows you to create as many aliases as the account limits.
resource "aws_kms_alias" "this" {
  for_each = toset(var.aliases)

  name          = each.key
  target_key_id = aws_kms_key.this.key_id
}
