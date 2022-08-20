output "default_parameter_tier" {
  description = "The parameter tier to use by default when a request to create or update a parameter does not specify a tier."
  value       = var.default_parameter_tier
}

output "high_throughput_enabled" {
  description = "Whether to increase Parameter Store throughput."
  value       = var.high_throughput_enabled
}
