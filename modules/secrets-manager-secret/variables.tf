variable "name" {
  description = "(Required) Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: `/_+=.@-`."
  type        = string
}

variable "description" {
  description = "(Optional) The description of the secret."
  type        = string
  default     = "Managed by Terraform."
}

variable "type" {
  description = "(Optional) The intended type of the secret. Valid values are `TEXT`, `KEY_VALUE` or `BINARY`."
  type        = string
  default     = "KEY_VALUE"

  validation {
    condition     = contains(["TEXT", "KEY_VALUE", "BINARY"], var.type)
    error_message = "Valid values are `TEXT`, `KEY_VALUE` or `BINARY`."
  }
}

variable "value" {
  description = "(Optional) The secret value that you want to encrypt and store in the current version of the secret. Specify plaintext data with `string` type if `type` is `TEXT`. Specify key-value data with `map` type if `type` is `KEY_VALUE`. Specify binary data with `string` type if `type` is `BINARY`. The `aws_secretsmanager_secret_version` resource is deleted from Terraform if you set the value to `null`. However, `AWSCURRENT` staging label is still active on the version event after the resource is deleted from Terraform."
  type        = any
  default     = null
}

variable "versions" {
  description = <<EOF
  (Optional) A list of versions other than `AWSCURRENT` version of the Secrets Manager secret. Each value of `versions` block as defined below.
    (Required) `value` - The secret value that you want to encrypyt and store in this version of the secret. Specify plaintext data with `string` type if `type` is `TEXT`. Specify key-value data with `map` type if `type` is `KEY_VALUE`. Specify binary data with `string` type if `type` is `BINARY`.
    (Required) `labels` - A list of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret. If you specify a staging label that's already associated with a different version of the same secret then that staging label is automatically removed from the other version and attached to this version.
  EOF
  type        = any
  default     = []

  validation {
    condition = alltrue([
      alltrue([
        for version in var.versions :
        version.value != null
      ]),
      alltrue([
        for version in var.versions :
        length(version.labels) > 0
      ]),
      alltrue([
        for version in var.versions :
        alltrue([
          for label in version.labels :
          !contains(["AWSCURRENT", "AWSPENDING", "AWSPREVIOUS"], label)
        ])
      ])
    ])
    error_message = "Not valid parameters for `versions`."
  }
}

variable "kms_key" {
  description = "(Optional) The ARN or Id of the AWS KMS key to be used to encrypt the secret values in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key named `aws/secretsmanager`. If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
  type        = string
  default     = null
}

variable "policy" {
  description = "(Optional) A valid JSON document representing a resource policy."
  type        = string
  default     = null
}

variable "block_public_policy" {
  description = "(Optional) Whether to reject calls to PUT a resource policy if the policy allows public access."
  type        = bool
  default     = false
}

variable "deletion_window_in_days" {
  description = "(Optional) Duration in days after which the secret is deleted after destruction of the resource. Valid value is between `7` and `30` days. Defaults to `30`."
  type        = number
  default     = 30

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
  type        = list(map(string))
  default     = []
}

variable "overwrite_in_replicas" {
  description = "(Optional) Whether to overwrite a secret with the same name in the destination region during replication."
  type        = bool
  default     = false
}

variable "rotation_lambda_function" {
  description = "(Optional) The ARN of the Lambda function that can rotate the secret."
  type        = string
  default     = null
}

variable "rotation_duration_in_days" {
  description = "(Optional) The number of days between automatic scheduled rotations of the secret. Required if `rotation_lambda_function` is configured."
  type        = number
  default     = null
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
