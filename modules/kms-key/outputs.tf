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

output "description" {
  description = "The description of the KMS key."
  value       = aws_kms_key.this.description
}

output "enabled" {
  description = "Whether the key is enabled."
  value       = aws_kms_key.this.is_enabled
}

output "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource."
  value       = aws_kms_key.this.deletion_window_in_days
}

output "usage" {
  description = "The usage of the KMS key."
  value       = aws_kms_key.this.key_usage
}

output "spec" {
  description = "The specification of KMS key which is the encryption algorithm or signing algorithm."
  value       = aws_kms_key.this.customer_master_key_spec
}

output "policy" {
  description = "The Resource Policy for KMS Key."
  value       = one(aws_kms_key_policy.this[*].policy)
}

output "custom_key_store" {
  description = "The ID of the KMS Custom Key Store where the key will be stored instead of KMS."
  value       = aws_kms_key.this.custom_key_store_id
}

output "xks_key" {
  description = "The ID of the external key that serves as key material for the KMS key in an external key store."
  value       = aws_kms_key.this.xks_key_id
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
