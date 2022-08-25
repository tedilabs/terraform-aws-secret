locals {
  metadata = {
    package = "terraform-aws-secret"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.path
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

resource "aws_ssm_parameter" "this" {
  for_each = {
    for parameter in var.parameters :
    parameter.name => parameter
    if !var.ignore_value_changes
  }

  name        = join("", [var.path, each.key])
  description = try(each.value.description, var.description)
  tier        = local.tiers[try(each.value.tier, var.tier)]

  type            = local.types[try(each.value.type, var.type)]
  data_type       = try(each.value.data_type, var.data_type)
  allowed_pattern = try(each.value.allowed_pattern, var.allowed_pattern)

  insecure_value = each.value.value

  # BUG: https://github.com/hashicorp/terraform-provider-aws/issues/25335
  overwrite = true

  tags = merge(
    {
      "Name" = join("", [var.path, each.key])
    },
    local.module_tags,
    var.tags,
  )
}

resource "aws_ssm_parameter" "self" {
  for_each = {
    for parameter in var.parameters :
    parameter.name => parameter
    if var.ignore_value_changes
  }

  name        = join("", [var.path, each.key])
  description = try(each.value.description, var.description)
  tier        = local.tiers[try(each.value.tier, var.tier)]

  type            = local.types[try(each.value.type, var.type)]
  data_type       = try(each.value.data_type, var.data_type)
  allowed_pattern = try(each.value.allowed_pattern, var.allowed_pattern)

  insecure_value = each.value.value

  # BUG: https://github.com/hashicorp/terraform-provider-aws/issues/25335
  overwrite = true

  tags = merge(
    {
      "Name" = join("", [var.path, each.key])
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
