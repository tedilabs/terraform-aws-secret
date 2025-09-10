output "path" {
  description = "The path used for the prefix of each parameter names managed by this parameter set."
  value       = var.path
}

output "parameters" {
  description = "The list of parameters in the parameter set."
  value = {
    for name, parameter in module.this :
    name => {
      id          = parameter.id
      arn         = parameter.arn
      name        = parameter.name
      description = parameter.description
      tier        = parameter.tier

      type            = parameter.type
      data_type       = parameter.data_type
      allowed_pattern = parameter.allowed_pattern

      value   = parameter.value
      version = parameter.version
    }
  }
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
