locals {
  grants = {
    for grant in var.grants :
    grant.name => {
      id                 = aws_kms_grant.this[grant.name].grant_id
      name               = aws_kms_grant.this[grant.name].name
      grantee_principal  = aws_kms_grant.this[grant.name].grantee_principal
      operations         = aws_kms_grant.this[grant.name].operations
      retiring_principal = aws_kms_grant.this[grant.name].retiring_principal

      constraints = grant.constraints
    }
  }
}

output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_kms_key.this.region
}

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

output "key_rotation" {
  description = "The key rotation configuration of the KMS key."
  value = {
    enabled        = aws_kms_key.this.enable_key_rotation
    period_in_days = aws_kms_key.this.rotation_period_in_days
  }
}

# NOTE: `grant_token` is intentionally not included in outputs because :
# - Grant tokens are only returned during grant creation and cannot be retrieved afterwards
# - Since Terraform-managed grants are created during infrastructure provisioning, they are already propagated by the time applications run, making tokens unnecessary
# - For immediate access needs, applications should create grants at runtime and use the returned tokens directly rather than relying on pre-provisioned grants
output "grants" {
  description = "A collection of grants for the key."
  value       = local.grants
}

output "predefined_policies" {
  description = "The predefined policies that have access to the KMS key."
  value       = var.predefined_policies
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

# output "debug" {
#   value = {
#     key = {
#       for k, v in aws_kms_key.this :
#       k => v
#       if !contains(["key_id", "arn", "description", "is_enabled", "deletion_window_in_days", "key_usage", "customer_master_key_spec", "enable_key_rotation", "rotation_period_in_days", "custom_key_store_id", "xks_key_id", "multi_region", "tags", "tags_all", "id", "timeouts", "policy", "bypass_policy_lockout_safety_check"], k)
#     }
#     grants = {
#       for name, grant in aws_kms_grant.this :
#       name => {
#         for k, v in grant :
#         k => v
#         if !contains(["grant_id", "name", "id", "key_id", "grantee_principal", "operations", "retiring_principal", "retire_on_delete", "constraints", "grant_creation_tokens", "grant_token"], k)
#       }
#     }
#   }
# }
