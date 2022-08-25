output "path" {
  description = "The path used for the prefix of each parameter names managed by this parameter set."
  value       = var.path
}

output "parameters" {
  description = "The list of parameters in the parameter set."
  value = {
    for name, parameter in aws_ssm_parameter.this :
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
