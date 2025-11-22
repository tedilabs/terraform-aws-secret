output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_secretsmanager_secret.this.region
}

output "arn" {
  description = "The ARN of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "id" {
  description = "The ID of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.id
}

output "name" {
  description = "The name of the secret."
  value       = aws_secretsmanager_secret.this.name
}

output "description" {
  description = "The description of the secret."
  value       = aws_secretsmanager_secret.this.description
}

output "type" {
  description = "The type of the secret."
  value       = var.type
}

output "value" {
  description = "The secret value in the current version of the secret with `AWSCURRENT` staging label."
  value = (length(aws_secretsmanager_secret_version.latest) > 0
    ? try(
      jsondecode(aws_secretsmanager_secret_version.latest[0].secret_string),
      coalesce(
        aws_secretsmanager_secret_version.latest[0].secret_string,
        aws_secretsmanager_secret_version.latest[0].secret_binary,
      ),
      null,
    )
    : null
  )
  sensitive = true
}

output "versions" {
  description = "A list of versions other than the current version of the secret."
  value = [
    for id, version in aws_secretsmanager_secret_version.versions : {
      id  = id
      arn = version.arn
      value = try(
        jsondecode(version.secret_string),
        coalesce(
          version.secret_string,
          version.secret_binary,
        ),
        null,
      )
      labels = version.version_stages
    }
  ]
  sensitive = true
}

output "kms_key" {
  description = "The ARN or Id of the AWS KMS key which is used to encrypt the secret values in this secret."
  value       = aws_secretsmanager_secret.this.kms_key_id
}

output "policy" {
  description = "The Resource Policy for the secret."
  value       = try(aws_secretsmanager_secret_policy.this[0].policy, null)
}

output "deletion_window_in_days" {
  description = "Duration in days after which the secret is deleted after destruction of the resource."
  value       = aws_secretsmanager_secret.this.recovery_window_in_days
}

output "rotation" {
  description = "The configuration of the automatic rotation for the secret."
  value = {
    enabled         = var.rotation.enabled
    lambda_function = one(aws_secretsmanager_secret_rotation.this[*].rotation_lambda_arn)

    schedule_frequency  = var.rotation.schedule_frequency
    schedule_expression = one(aws_secretsmanager_secret_rotation.this[*].rotation_rules[0].schedule_expression)
    duration_in_days    = var.rotation.duration
  }
}

output "replicas" {
  description = "The information for regional replications of the secret."
  value = {
    for replica in aws_secretsmanager_secret.this.replica :
    replica.region => {
      kms_key = replica.kms_key_id

      status         = replica.status
      status_message = replica.status_message
    }
  }
}

output "overwrite_in_replicas" {
  description = "Whether to overwrite a secret with the same name in the destination region during replication."
  value       = aws_secretsmanager_secret.this.force_overwrite_replica_secret
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
#     for k, v in aws_secretsmanager_secret.this :
#     k => v
#     if !contains(["tags", "tags_all", "policy", "id", "arn", "name", "description", "kms_key_id", "recovery_window_in_days", "force_overwrite_replica_secret", "name_prefix", "replica"], k)
#   }
# }
