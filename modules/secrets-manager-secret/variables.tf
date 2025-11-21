variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: `/_+=.@-`."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) The description of the secret."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "type" {
  description = "(Optional) The intended type of the secret. Valid values are `TEXT`, `KEY_VALUE` or `BINARY`."
  type        = string
  default     = "KEY_VALUE"
  nullable    = false

  validation {
    condition     = contains(["TEXT", "KEY_VALUE", "BINARY"], var.type)
    error_message = "Valid values are `TEXT`, `KEY_VALUE` or `BINARY`."
  }
}

variable "binary_value" {
  description = "(Optional) The secret value in base64-encoded binary that you want to encrypt and store in the current version of the secret. Only used if `type` is `BINARY`. The `aws_secretsmanager_secret_version` resource is deleted from Terraform if you set the value to `null`. However, `AWSCURRENT` staging label is still active on the version event after the resource is deleted from Terraform."
  type        = string
  default     = null
  nullable    = true
}

variable "kv_value" {
  description = "(Optional) The secret value in key/value that you want to encrypt and store in the current version of the secret. Only used if `type` is `KEY_VALUE`. The `aws_secretsmanager_secret_version` resource is deleted from Terraform if you set the value to `null`. However, `AWSCURRENT` staging label is still active on the version event after the resource is deleted from Terraform."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "text_value" {
  description = "(Optional) The secret value in text that you want to encrypt and store in the current version of the secret. Only used if `type` is `TEXT`. The `aws_secretsmanager_secret_version` resource is deleted from Terraform if you set the value to `null`. However, `AWSCURRENT` staging label is still active on the version event after the resource is deleted from Terraform."
  type        = string
  default     = null
  nullable    = true
}

variable "versions" {
  description = <<EOF
  (Optional) A list of versions other than `AWSCURRENT` version of the Secrets Manager secret. Each value of `versions` block as defined below.
    (Optioinal) `text_value` - The secret value in text that you want to encrypt and store in this version of the secret. Only used if `type` is `TEXT`.
    (Optional) `kv_value` - The secret value in key/value that you want to encrypt and store in this version of the secret. Only used if `type` is `KEY_VALUE`.
    (Optional) `binary_value` - The secret value in base64-encoded binary that you want to encrypt and store in this version of the secret. Only used if `type` is `BINARY`.
    (Required) `labels` - A set of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret. If you specify a staging label that's already associated with a different version of the same secret then that staging label is automatically removed from the other version and attached to this version.
  EOF
  type = list(object({
    binary_value = optional(string)
    kv_value     = optional(map(string), {})
    text_value   = optional(string)
    labels       = set(string)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for version in var.versions :
      anytrue([
        var.type == "TEXT" && version.text_value != null,
        var.type == "KEY_VALUE" && length(version.kv_value) > 0,
        var.type == "BINARY" && version.binary_value != null,
      ])
    ])
    error_message = "Each version must have a value corresponding to the specified `type`."
  }
  validation {
    condition = alltrue([
      for version in var.versions :
      length(version.labels) > 0
    ])
    error_message = "Each version must have at least one label."
  }
  validation {
    condition = alltrue([
      for version in var.versions :
      alltrue([
        for label in version.labels :
        !contains(["AWSCURRENT", "AWSPENDING", "AWSPREVIOUS"], label)
      ])
    ])
    error_message = "Staging labels `AWSCURRENT`, `AWSPENDING`, and `AWSPREVIOUS` cannot be set manually in `versions`."
  }
}

variable "kms_key" {
  description = "(Optional) The ARN or Id of the AWS KMS key to be used to encrypt the secret values in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key named `aws/secretsmanager`. If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
  type        = string
  default     = null
  nullable    = true
}

variable "policy" {
  description = "(Optional) A valid JSON document representing a resource policy."
  type        = string
  default     = null
  nullable    = true
}

variable "block_public_policy" {
  description = "(Optional) Whether to reject calls to PUT a resource policy if the policy allows public access. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "deletion_window_in_days" {
  description = "(Optional) Duration in days after which the secret is deleted after destruction of the resource. Valid value is between `7` and `30` days. Defaults to `30`."
  type        = number
  default     = 30
  nullable    = false

  validation {
    condition = alltrue([
      var.deletion_window_in_days >= 7,
      var.deletion_window_in_days <= 30,
    ])
    error_message = "Valid value is between `7` and `30` days."
  }
}

variable "replicas" {
  description = <<EOF
  (Optional) A list of replica configurations of the Secrets Manager secret. Each value of `replicas` block as defined below.
    (Required) `region` - The region for replicating the secret.
    (Optional) `kms_key` - The ARN, Key ID, or Alias of the AWS KMS key within the region secret is replicated to. If one is not specified, then Secrets Manager defaults to using the AWS account's default KMS key named `aws/secretsmanager` in the region. If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time.
  EOF
  type = list(object({
    region  = string
    kms_key = optional(string)
  }))
  default  = []
  nullable = false
}

variable "overwrite_in_replicas" {
  description = "(Optional) Whether to overwrite a secret with the same name in the destination region during replication. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "rotation" {
  description = <<EOF
  (Optional) A rotation configurations of the Secrets Manager secret. `rotation` block as defined below.
    (Optional) `enabled` - Whether to enable automatic rotation of the secret. Defaults to `false`.
    (Optionial) `rotate_immediately` - Whether to rotate the secret immediately or wait until the next scheduled rotation window. The rotation schedule is defined in rotation_rules. For secrets that use a Lambda rotation function to rotate, if you don't immediately rotate the secret, Secrets Manager tests the rotation configuration by running the testSecret step. Defaults to `true`.
    (Optional) `lambda_function` - The ARN of the Lambda function that can rotate the secret.
    (Optional) `schedule_frequency` - The number of days between automatic scheduled rotations of the secret. Either `schedule_frequency` or `schedule_expression` must be specified.
    (Optional) `schedule_expression` - A cron expression such as `cron(a b c d e f)` or a rate expression such as `rate(10 days)`. Either `schedule_frequency` or `schedule_expression` must be specified.
    (Optional) `duration` - The length of the rotation window in hours.
  EOF
  type = object({
    enabled             = optional(bool, false)
    rotate_immediately  = optional(bool, true)
    lambda_function     = optional(string)
    schedule_frequency  = optional(number)
    schedule_expression = optional(string)
    duration            = optional(number)
  })
  default  = {}
  nullable = false

  validation {
    condition = anytrue([
      var.rotation.duration == null,
      var.rotation.duration != null && coalesce(var.rotation.duration, 0) > 0,
    ])
    error_message = "Valid value for `duration` is greater than `0`."
  }
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
