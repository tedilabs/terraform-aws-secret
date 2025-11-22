output "region" {
  description = "The AWS region this module resources resides in."
  value       = local.region
}

output "default_parameter_tier" {
  description = "The parameter tier to use by default when a request to create or update a parameter does not specify a tier."
  value = {
    for k, v in local.parameter_tiers :
    v => k
  }[aws_ssm_service_setting.this["default_parameter_tier"].setting_value]
}

output "high_throughput_enabled" {
  description = "Whether to increase Parameter Store throughput."
  value       = aws_ssm_service_setting.this["high-throughput-enabled"].setting_value == "true"
}
