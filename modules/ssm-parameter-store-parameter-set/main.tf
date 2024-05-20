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


###################################################
# Parameter on Systems Manager Parameter Store
###################################################

module "this" {
  for_each = {
    for parameter in var.parameters :
    parameter.name => parameter
  }

  source = "../ssm-parameter-store-parameter"

  name        = join("", [var.path, each.key])
  description = coalesce(each.value.description, var.description)
  tier        = coalesce(each.value.tier, var.tier)

  type      = coalesce(each.value.type, var.type)
  data_type = coalesce(each.value.data_type, var.data_type)
  allowed_pattern = (each.value.allowed_pattern != null
    ? each.value.allowed_pattern
    : var.allowed_pattern
  )

  ignore_value_changes = var.ignore_value_changes
  value                = each.value.value

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    {
      "Name" = join("", [var.path, each.key])
    },
    local.module_tags,
    var.tags,
  )
}
