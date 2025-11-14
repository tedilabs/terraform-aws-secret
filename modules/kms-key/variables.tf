variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) Name of the KMS key."
  type        = string
  nullable    = false
}

variable "aliases" {
  description = "(Optional) A set of display name of the alias. The name must start with the word ``alias/`."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "description" {
  description = "(Optional) The description of the KMS key."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "enabled" {
  description = "(Optional) Indicates whether the key is enabled. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "deletion_window_in_days" {
  description = "(Optional) Duration in days after which the key is deleted after destruction of the resource. Valid value is between `7` and `30` days. Defaults to `30`."
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

variable "usage" {
  description = "(Optional) Specifies the intended use of the key. Valid values are `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, `GENERATE_VERIFY_MAC`, `KEY_AGREEMENT`. Defaults to `ENCRYPT_DECRYPT`."
  type        = string
  default     = "ENCRYPT_DECRYPT"
  nullable    = false

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC", "KEY_AGREEMENT"], var.usage)
    error_message = "Valid values are `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, `GENERATE_VERIFY_MAC`, or `KEY_AGREEMENT`."
  }
}

variable "spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_224`, `HMAC_256`, `HMAC_384`, `HMAC_512`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, `ECC_SECG_P256K1`, `ML_DSA_44`, `ML_DSA_65`, `ML_DSA_87`, or `SM2` (China Regions Only). Defaults to `SYMMETRIC_DEFAULT`."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  nullable    = false

  validation {
    condition = contains([
      "SYMMETRIC_DEFAULT",
      "RSA_2048",
      "RSA_3072",
      "RSA_4096",
      "HMAC_224",
      "HMAC_256",
      "HMAC_384",
      "HMAC_512",
      "ECC_NIST_EDWARDS25519",
      "ECC_NIST_P256",
      "ECC_NIST_P384",
      "ECC_NIST_P521",
      "ECC_SECG_P256K1",
      "ML_DSA_44",
      "ML_DSA_65",
      "ML_DSA_87",
      "SM2",
    ], var.spec)
    error_message = "Valid values for `spec` are `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_224`, `HMAC_256`, `HMAC_384`, `HMAC_512`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, `ECC_SECG_P256K1`, `ML_DSA_44`, `ML_DSA_65`, `ML_DSA_87`, or `SM2` (China Regions Only)."
  }
}

variable "key_rotation" {
  description = <<EOF
  (Optional) A configuration for key rotation of the KMS key. This configuration is only applicable for symmetric encryption KMS keys. `key_rotation` block as defined below.
    (Optional) `enabled` - Whether key rotation is enabled. Defaults to `false`.
    (Optional) `period_in_days` - The custom period of t ime between each key rotation. Valid value is between `90` and `2560` days (inclusive). Defaults to `365`.
  EOF
  type = object({
    enabled        = optional(bool, false)
    period_in_days = optional(number, 365)
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      var.key_rotation.period_in_days >= 90,
      var.key_rotation.period_in_days <= 2560,
    ])
    error_message = "Valid value for `period_in_days` is between `90` and `2560` days (inclusive)."
  }
}

variable "grants" {
  description = <<EOF
  (Optional) A list of grants configuration for granting access to the KMS key. Each item of `grants` as defined below.
    (Required) `name` - A friendly name for the grant.
    (Required) `grantee_principal` - The principal that is given permission to perform the operations that the grant permits in ARN format.
    (Required) `operations` - A set of operations that the grant permits. Valid values are `Encrypt`, `Decrypt`, `GenerateDataKey`, `GenerateDataKeyWithoutPlaintext`, `ReEncryptFrom`, `ReEncryptTo`, `CreateGrant`, `RetireGrant`, `DescribeKey`, `GenerateDataKeyPair`, `GenerateDataKeyPairWithoutPlaintext`, `GetPublicKey`, `Sign`, `Verify`, `GenerateMac`, `VerifyMac`, or `DeriveSharedSecret`.
    (Optional) `retiring_principal` - The principal that is given permission to retire the grant by using RetireGrant operation in ARN format.
    (Optional) `retire_on_delete` - Whether to retire the grant upon deletion. Defaults to `false`.
      Retire: Grantee returns permissions voluntarily (normal termination)
      Revoke: Admin forcefully cancels permissions (emergency termination)
    (Optional) `grant_creation_tokens` - A list of grant tokens to be used when creating the grant. Use grant token for immediate access without waiting for grant propagation (up to 5 min). Required for time-sensitive operations.
    (Optional) `constraints` - A configuration for grant constraints. `constraints` block as defined below.
      (Optional) `type` - The type of constraints. Valid values are `ENCRYPTION_CONTEXT_EQUALS` or `ENCRYPTION_CONTEXT_SUBSET`. Defaults to `ENCRYPTION_CONTEXT_SUBSET`.
      (Optional) `value` - A map of key-value pair to be validated against the encryption context during cryptographic operations.
  EOF
  type = list(object({
    name              = string
    grantee_principal = string
    operations        = set(string)

    retiring_principal    = optional(string)
    retire_on_delete      = optional(bool, false)
    grant_creation_tokens = optional(list(string))

    constraints = optional(object({
      type  = optional(string, "ENCRYPTION_CONTEXT_SUBSET")
      value = map(string)
    }))
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for grant in var.grants :
      alltrue([
        for op in grant.operations :
        contains([
          "Encrypt",
          "Decrypt",
          "GenerateDataKey",
          "GenerateDataKeyWithoutPlaintext",
          "ReEncryptFrom",
          "ReEncryptTo",
          "CreateGrant",
          "RetireGrant",
          "DescribeKey",
          "GenerateDataKeyPair",
          "GenerateDataKeyPairWithoutPlaintext",
          "GetPublicKey",
          "Sign",
          "Verify",
          "GenerateMac",
          "VerifyMac",
          "DeriveSharedSecret",
        ], op)
      ])
    ])
    error_message = "Valid values for grant operations are `Encrypt`, `Decrypt`, `GenerateDataKey`, `GenerateDataKeyWithoutPlaintext`, `ReEncryptFrom`, `ReEncryptTo`, `CreateGrant`, `RetireGrant`, `DescribeKey`, `GenerateDataKeyPair`, `GenerateDataKeyPairWithoutPlaintext`, `GetPublicKey`, `Sign`, `Verify`, `GenerateMac`, `VerifyMac`, or `DeriveSharedSecret`."
  }

  validation {
    condition = alltrue([
      for grant in var.grants :
      contains([
        "ENCRYPTION_CONTEXT_EQUALS",
        "ENCRYPTION_CONTEXT_SUBSET"
      ], grant.constraints.type)
      if grant.constraints != null
    ])
    error_message = "Valid values for `constraints.type` are `ENCRYPTION_CONTEXT_EQUALS` or `ENCRYPTION_CONTEXT_SUBSET`."
  }
  validation {
    condition = alltrue([
      for grant in var.grants :
      anytrue([
        grant.constraints == null,
        grant.constraints != null && length(keys(grant.constraints.value)) > 0,
      ])
    ])
    error_message = "If `constraints` is defined, it must contain at least one key-value pair in `value`."
  }
}

variable "predefined_policies" {
  description = <<EOF
  (Optional) A configuration for predefined policies of the KMS key. This configuration will be merged with given `policy` if it is defined. Each item of `predefined_policies` block as defined below.
    (Required) `role` - The predefined role to be applied to the KMS key. Valid values are `OWNER`, `ADMINISTRATOR`, `USER`, `SERVICE_USER`, `SYMMETRIC_ENCRYPTION`, `ASYMMETRIC_ENCRYPTION`, `ASYMMETRIC_SIGNING`, or `HMAC`.
      `OWNER` - Full access to the KMS key, including permission to modify the key policy and delete the key.
      `ADMINISTRATOR` - Administrative access to the KMS key, including permission to modify the key policy, but not permission to delete the key.
      `USER` - Access to use the KMS key for cryptographic operations, but not administrative permissions.
      `SERVICE_USER` - Access for AWS services to use the KMS key for cryptographic operations on your behalf.
      `SYMMETRIC_ENCRYPTION` - Access to use the KMS key for symmetric encryption and decryption operations.
      `ASYMMETRIC_ENCRYPTION` - Access to use the KMS key for asymmetric encryption and decryption operations.
      `ASYMMETRIC_SIGNING` - Access to use the KMS key for asymmetric signing and verification operations.
      `HMAC` - Access to use the KMS key for HMAC generation and verification operations.
    (Required) `iam_entities` - A set of ARNs of AWS IAM entities who can be permitted to access the KMS key for the predefined role.
    (Optional) `conditions` - A list of required conditions to be met to allow the predefined role access to the KMS key. Each item of `conditions` block as defined below.
      (Required) `key` - The key to match a condition for when a policy is in effect.
      (Required) `condition` - The condition operator to match the condition keys and values in the policy against keys and values in the request context. Examples: `StringEquals`, `StringLike`.
      (Required) `values` - A list of allowed values of the key to match a condition with condition operator.
  EOF
  type = list(object({
    role         = string
    iam_entities = set(string)
    conditions = optional(list(object({
      key       = string
      condition = string
      values    = list(string)
    })), [])
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for policy in var.predefined_policies :
      contains([
        "OWNER",
        "ADMINISTRATOR",
        "USER",
        "SERVICE_USER",
        "SYMMETRIC_ENCRYPTION",
        "ASYMMETRIC_ENCRYPTION",
        "ASYMMETRIC_SIGNING",
        "HMAC",
      ], policy.role)
    ])
    error_message = "Valid values for `role` are `OWNER`, `ADMINISTRATOR`, `USER`, `SERVICE_USER`, `SYMMETRIC_ENCRYPTION`, `ASYMMETRIC_ENCRYPTION`, `ASYMMETRIC_SIGNING`, or `HMAC`."
  }
}

variable "policy" {
  description = "(Optional) A valid policy JSON document. Although this is a key policy, not an IAM policy, an `aws_iam_policy_document`, in the form that designates a principal, can be used."
  type        = string
  default     = null
  nullable    = true
}

variable "bypass_policy_lockout_safety_check" {
  description = "(Optional) Whether to bypass the key policy lockout safety check performed when creating or updating the key's policy. Setting this value to true increases the risk that the CMK becomes unmanageable. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "custom_key_store" {
  description = "(Optional) The ID of the KMS Custom Key Store where the key will be stored instead of KMS. This parameter is valid only for symmetric encryption KMS keys in a single region."
  type        = string
  default     = null
  nullable    = true
}

variable "xks_key" {
  description = "(Optional) The ID of the external key that serves as key material for the KMS key in an external key store."
  type        = string
  default     = null
  nullable    = true
}

variable "multi_region_enabled" {
  description = "(Optional) Indicates whether the key is a multi-Region (true) or regional (false) key. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
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
