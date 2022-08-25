locals {
  parameter_set = var.ignore_value_changes ? aws_ssm_parameter.self : aws_ssm_parameter.this
}

output "path" {
  description = "The path used for the prefix of each parameter names managed by this parameter set."
  value       = var.path
}

output "parameters" {
  description = "The list of parameters in the parameter set."
  value = {
    for name, parameter in local.parameter_set :
    name => {
      id          = parameter.id
      arn         = parameter.arn
      name        = parameter.name
      description = parameter.description
      tier        = parameter.tier

      type            = parameter.type
      data_type       = parameter.data_type
      allowed_pattern = parameter.allowed_pattern

      value   = parameter.insecure_value
      version = parameter.version
    }
  }
}
