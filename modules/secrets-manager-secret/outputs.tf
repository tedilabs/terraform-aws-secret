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
  value = try(coalesce(
    one(aws_secretsmanager_secret_version.latest.*.secret_string),
    one(aws_secretsmanager_secret_version.latest.*.secret_binary),
  ), null)
}

output "versions" {
  description = "A list of versions other than the current version of the secret."
  value = [
    for id, version in aws_secretsmanager_secret_version.versions : {
      id = id
      value = coalesce(
        version.secret_string,
        version.secret_binary,
      )
      labels = version.version_stages
    }
  ]
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
    enabled          = var.rotation_lambda_function != null
    lambda_function  = one(aws_secretsmanager_secret_rotation.this.*.rotation_lambda_arn)
    duration_in_days = var.rotation_duration_in_days
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
