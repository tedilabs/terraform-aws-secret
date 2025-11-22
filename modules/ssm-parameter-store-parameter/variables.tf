variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) Friendly name of the new parameter. If the name contains a path (e.g., any forward slashes (/)), it must be fully qualified with a leading forward slash (/)."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) The description of the parameter."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "tier" {
  description = "(Optional) The parameter tier to assign to the parameter. If not specified, will use the default parameter tier for the region. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (var.tier != null
      ? contains(["STANDARD", "ADVANCED", "INTELLIGENT_TIERING"], var.tier)
      : true
    )
    error_message = "Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`."
  }
}

variable "type" {
  description = "(Optional) The intended type of the parameter. Valid values are `STRING`, `STRING_LIST` or `SECURE_STRING`. Defaults to `STRING`."
  type        = string
  default     = "STRING"
  nullable    = false

  validation {
    condition     = contains(["STRING", "STRING_LIST", "SECURE_STRING"], var.type)
    error_message = "Valid values are `STRING`, `STRING_LIST` or `SECURE_STRING`."
  }
}

variable "data_type" {
  description = "(Optional) The data type of the parameter. Only required when `type` is `STRING`. Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image` for AMI format. Defaults to `text`. `aws:ssm:integration` data_type parameters must be of the type `SECURE_STRING` and the name must start with the prefix `/d9d01087-4a3f-49e0-b0b4-d568d7826553/ssm/integrations/webhook/`."
  type        = string
  default     = "text"
  nullable    = false

  validation {
    condition     = contains(["text", "aws:ssm:integration", "aws:ec2:image"], var.data_type)
    error_message = "Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image`."
  }
}

variable "allowed_pattern" {
  description = "(Optional) A regular expression used to validate the parameter value. For example, for `STRING` types with values restricted to numbers, you can specify `^d+$`."
  type        = string
  default     = ""
  nullable    = false
}

variable "value" {
  description = "(Required) The value of the parameter. This argument is not valid with a type of `SECURE_STRING`"
  type        = string
  default     = ""
  nullable    = false
}

variable "secret_value" {
  description = "(Required) The secure value of the parameter. This argument is valid with a type of `SECURE_STRING`"
  type        = string
  default     = ""
  nullable    = false
  sensitive   = true
}

variable "kms_key" {
  description = "(Optional) The ARN or ID of the AWS KMS key to be used to encrypt the parameter value with `SECURE_STRING` type. If you don't specify this value, then Parameter Store defaults to using the AWS account's default KMS key named `aws/ssm`. If the default KMS key with that name doesn't yet exist, then AWS Parameter Store creates it for you automatically the first time."
  type        = string
  default     = null
}

variable "ignore_value_changes" {
  description = "(Optional) Whether to manage the parameter value with Terraform. Ignore changes of `value` or `secret_value` if true. Defaults to `false`."
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
