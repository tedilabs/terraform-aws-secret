output "arn" {
  description = "The ARN of the KMS key."
  value       = aws_kms_key.this.arn
}

output "id" {
  description = "The ID of the KMS key."
  value       = aws_kms_key.this.key_id
}

output "name" {
  description = "The KMS Key name."
  value       = var.name
}

output "usage" {
  description = "The usage of the KMS key. `ENCRYPT_DECRYPT` or `SIGN_VERIFY`."
  value       = aws_kms_key.this.key_usage
}

output "spec" {
  description = "The specification of KMS key which is the encryption algorithm or signing algorithm."
  value       = aws_kms_key.this.customer_master_key_spec
}

output "policy" {
  description = "The Resource Policy for KMS Key."
  value       = aws_kms_key.this.policy
}

output "bypass_policy_lockout_safety_check" {
  description = "Whether to disable the policy lockout check performed when creating or updating the key's policy."
  value       = aws_kms_key.this.bypass_policy_lockout_safety_check
}

output "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource."
  value       = aws_kms_key.this.deletion_window_in_days
}

output "enabled" {
  description = "Whether the key is enabled."
  value       = aws_kms_key.this.is_enabled
}

output "key_rotation_enabled" {
  description = "Whether the key rotation is enabled."
  value       = aws_kms_key.this.enable_key_rotation
}

output "multi_region_enabled" {
  description = "Whether the key is a multi-region key."
  value       = aws_kms_key.this.multi_region
}

output "aliases" {
  description = "A collection of aliases of the key."
  value = {
    for alias in aws_kms_alias.this :
    alias.name => {
      arn  = alias.arn
      name = alias.name
    }
  }
}
