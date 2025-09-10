locals {
  parameter = try(aws_ssm_parameter.this[0], aws_ssm_parameter.self[0])
}

output "arn" {
  description = "The ARN of the parameter."
  value       = local.parameter.arn
}

output "id" {
  description = "The ID of the parameter."
  value       = local.parameter.id
}

output "name" {
  description = "The name of the parameter."
  value       = local.parameter.name
}

output "description" {
  description = "The description of the parameter."
  value       = local.parameter.description
}

output "tier" {
  description = "The tier of the parameter."
  value = {
    for k, v in local.tiers :
    v => k
  }[local.parameter.tier]
}

output "type" {
  description = "The type of the parameter."
  value = {
    for k, v in local.types :
    v => k
  }[local.parameter.type]
}

output "data_type" {
  description = "The data type of the parameter. Only required when `type` is `STRING`."
  value       = local.parameter.data_type
}

output "allowed_pattern" {
  description = "The regular expression used to validate the parameter value."
  value       = local.parameter.allowed_pattern
}

output "value" {
  description = "The value of the parameter. argument is not valid with a type of `SECURE_STRING`."
  value       = local.parameter.insecure_value
}

output "secret_value" {
  description = "The secure value of the parameter. argument is valid with a type of `SECURE_STRING`."
  value       = local.parameter.value
  sensitive   = true
}

output "kms_key" {
  description = "The ARN or ID of the AWS KMS key which is used to encrypt the parameter value."
  value       = local.parameter.key_id
}

output "version" {
  description = "The current version of the parameter."
  value       = local.parameter.version
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
