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
  value       = aws_kms_replica_key.this.region
}

output "arn" {
  description = "The ARN of the replica key."
  value       = aws_kms_replica_key.this.arn
}

output "id" {
  description = "The ID of the replica key."
  value       = aws_kms_replica_key.this.key_id
}

output "primary_key" {
  description = "The ARN of the primary key for which this key is a replica."
  value = {
    arn = aws_kms_replica_key.this.primary_key_arn
  }
}

output "name" {
  description = "The KMS Key name."
  value       = var.name
}

output "description" {
  description = "The description of the replica key."
  value       = aws_kms_replica_key.this.description
}

output "enabled" {
  description = "Whether the replica key is enabled."
  value       = aws_kms_replica_key.this.enabled
}

output "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource."
  value       = aws_kms_replica_key.this.deletion_window_in_days
}

output "usage" {
  description = "The usage of the replica key."
  value       = aws_kms_replica_key.this.key_usage
}

output "spec" {
  description = "The specification of replica key which is the encryption algorithm or signing algorithm."
  value       = aws_kms_replica_key.this.key_spec
}

output "key_rotation" {
  description = "The key rotation configuration of the replica key."
  value = {
    enabled = aws_kms_replica_key.this.key_rotation_enabled
    # period_in_days = aws_kms_replica_key.this.rotation_period_in_days
  }
}

# NOTE: `grant_token` is intentionally not included in outputs because :
# - Grant tokens are only returned during grant creation and cannot be retrieved afterwards
# - Since Terraform-managed grants are created during infrastructure provisioning, they are already propagated by the time applications run, making tokens unnecessary
# - For immediate access needs, applications should create grants at runtime and use the returned tokens directly rather than relying on pre-provisioned grants
# output "grants" {
#   description = "A collection of grants for the key."
#   value       = local.grants
# }

output "predefined_policies" {
  description = "The predefined policies that have access to the replica key."
  value       = var.predefined_policies
}

output "policy" {
  description = "The Resource Policy for KMS Key."
  value       = one(aws_kms_key_policy.this[*].policy)
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
#       for k, v in aws_kms_replica_key.this :
#       k => v
#       if !contains(["key_id", "arn", "description", "enabled", "deletion_window_in_days", "key_usage", "key_spec", "key_rotation_enabled", "tags", "tags_all", "timeouts", "policy", "bypass_policy_lockout_safety_check", "id", "region", "primary_key_arn"], k)
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
