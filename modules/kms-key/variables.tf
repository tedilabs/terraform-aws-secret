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
  description = "(Optional) Specifies the intended use of the key. Valid values are `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, or `GENERATE_VERIFY_MAC`. Defaults to `ENCRYPT_DECRYPT`."
  type        = string
  default     = "ENCRYPT_DECRYPT"
  nullable    = false

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.usage)
    error_message = "Valid values are `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, or `GENERATE_VERIFY_MAC`."
  }
}

variable "spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT`."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  nullable    = false

  validation {
    condition = contains([
      "SYMMETRIC_DEFAULT",
      "RSA_2048",
      "RSA_3072",
      "RSA_4096",
      "HMAC_256",
      "ECC_NIST_P256",
      "ECC_NIST_P384",
      "ECC_NIST_P521",
      "ECC_SECG_P256K1",
    ], var.spec)
    error_message = "Valid values for `spec` are `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`."
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

variable "key_rotation_enabled" {
  description = "(Optional) Indicates whether key rotation is enabled. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
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

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
  nullable    = false
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
  nullable    = false
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}
