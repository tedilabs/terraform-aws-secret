output "arn" {
  description = "The ARN of the parameter."
  value       = aws_ssm_parameter.this.arn
}

output "id" {
  description = "The ID of the parameter."
  value       = aws_ssm_parameter.this.id
}

output "name" {
  description = "The name of the parameter."
  value       = aws_ssm_parameter.this.name
}

output "description" {
  description = "The description of the parameter."
  value       = aws_ssm_parameter.this.description
}

output "tier" {
  description = "The tier of the parameter."
  value = {
    for k, v in local.tiers :
    v => k
  }[aws_ssm_parameter.this.tier]
}

output "type" {
  description = "The type of the parameter."
  value = {
    for k, v in local.types :
    v => k
  }[aws_ssm_parameter.this.type]
}

output "data_type" {
  description = "The data type of the parameter. Only required when `type` is `STRING`."
  value       = aws_ssm_parameter.this.data_type
}

output "allowed_pattern" {
  description = "The regular expression used to validate the parameter value."
  value       = aws_ssm_parameter.this.allowed_pattern
}

output "value" {
  description = "The value of the parameter. This argument is not valid with a type of `SECURE_STRING`."
  value       = aws_ssm_parameter.this.insecure_value
}

output "secret_value" {
  description = "The secure value of the parameter. This argument is valid with a type of `SECURE_STRING`."
  value       = aws_ssm_parameter.this.value
  sensitive   = true
}

output "kms_key" {
  description = "The ARN or ID of the AWS KMS key which is used to encrypt the parameter value."
  value       = aws_ssm_parameter.this.key_id
}

output "version" {
  description = "The current version of the parameter."
  value       = aws_ssm_parameter.this.version
}
