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

locals {
  types = {
    "STRING"        = "String"
    "STRING_LIST"   = "StringList"
    "SECURE_STRING" = "SecureString"
  }
  tiers = {
    "STANDARD"            = "Standard"
    "ADVANCED"            = "Advanced"
    "INTELLIGENT_TIERING" = "Intelligent-Tiering"
  }
}


###################################################
# Parameter on Systems Manager Parameter Store
###################################################

# INFO: Deprecated attributes
# - `overwrite`
resource "aws_ssm_parameter" "this" {
  count = var.ignore_value_changes ? 0 : 1

  name        = var.name
  description = var.description
  tier        = var.tier != null ? local.tiers[var.tier] : null

  type            = local.types[var.type]
  data_type       = var.data_type
  allowed_pattern = var.allowed_pattern

  insecure_value = var.type == "SECURE_STRING" ? null : var.value
  value          = var.type == "SECURE_STRING" ? var.secret_value : null


  ## Encryption
  key_id = var.type == "SECURE_STRING" ? var.kms_key : null

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}

# INFO: Deprecated attributes
# - `overwrite`
resource "aws_ssm_parameter" "self" {
  count = var.ignore_value_changes ? 1 : 0

  name        = var.name
  description = var.description
  tier        = var.tier != null ? local.tiers[var.tier] : null

  type            = local.types[var.type]
  data_type       = var.data_type
  allowed_pattern = var.allowed_pattern

  insecure_value = var.type == "SECURE_STRING" ? null : var.value
  value          = var.type == "SECURE_STRING" ? var.secret_value : null


  ## Encryption
  key_id = var.type == "SECURE_STRING" ? var.kms_key : null

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )

  lifecycle {
    ignore_changes = [
      value,
      insecure_value,
    ]
  }
}
