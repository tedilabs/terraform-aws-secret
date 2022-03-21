variable "name" {
  description = "(Required) Name of the KMS key."
  type        = string
}

variable "description" {
  description = "(Optional) The description of the KMS key."
  type        = string
  default     = ""
}

variable "usage" {
  description = "(Optional) Specifies the intended use of the key. Valid values are `ENCRYPT_DECRYPT` or `SIGN_VERIFY`."
  type        = string
  default     = "ENCRYPT_DECRYPT"

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY"], var.usage)
    error_message = "Valid values are `ENCRYPT_DECRYPT` or `SIGN_VERIFY`."
  }
}

variable "spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT`."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "policy" {
  description = "(Optional) A valid policy JSON document. Although this is a key policy, not an IAM policy, an `aws_iam_policy_document`, in the form that designates a principal, can be used."
  type        = string
  default     = null
}

variable "bypass_policy_lockout_safety_check" {
  description = "(Optional) Specifies whether to disable the policy lockout check performed when creating or updating the key's policy. Setting this value to true increases the risk that the CMK becomes unmanageable. For more information, refer to the scenario in the Default Key Policy section in the AWS Key Management Service Developer Guide."
  type        = bool
  default     = false
}

variable "deletion_window_in_days" {
  description = "(Optional) Duration in days after which the key is deleted after destruction of the resource. Valid value is between `7` and `30` days. Defaults to `30`."
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

variable "enabled" {
  description = "(Optional) Indicates whether the key is enabled."
  type        = bool
  default     = true
}

variable "key_rotation_enabled" {
  description = "(Optional) Indicates whether key rotation is enabled."
  type        = bool
  default     = false
}

variable "multi_region_enabled" {
  description = "(Optional) Indicates whether the key is a multi-Region (true) or regional (false) key."
  type        = bool
  default     = false
}

variable "aliases" {
  description = "(Optional) List of display name of the alias. The name must start with the word ``alias/`."
  type        = list(string)
  default     = []
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
