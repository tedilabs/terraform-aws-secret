variable "path" {
  description = "(Required) A path used for the prefix of each parameter name created by this parameter set. The path should begin with slash (/) and end without trailing slash."
  type        = string
  nullable    = false

  validation {
    condition = alltrue([
      substr(var.path, 0, 1) == "/",
      substr(var.path, -1, 0) != "/",
    ])
    error_message = "The value of `path` should begin with slash (/) and end without trailing slash."
  }
}

variable "description" {
  description = "(Optional) The default description of parameters in the parameter set. This is only used when a specific description of the parameter is not provided."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "tier" {
  description = "(Optional) The default parameter tier to assign to parameters in the parameter set. This is only used when a specific tier of the parameter is not provided. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`. Defaults to `INTELLIGENT_TIERING`."
  type        = string
  default     = "INTELLIGENT_TIERING"
  nullable    = false

  validation {
    condition     = contains(["STANDARD", "ADVANCED", "INTELLIGENT_TIERING"], var.tier)
    error_message = "Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`."
  }
}

variable "type" {
  description = "(Optional) The default type of parameters in the parameter set. This is only used when a specific type of the parameter is not provided. Valid values are `STRING`, `STRING_LIST`. Not support `SECURE_STRING`. Defaults to `STRING`."
  type        = string
  default     = "STRING"
  nullable    = false

  validation {
    condition     = contains(["STRING", "STRING_LIST"], var.type)
    error_message = "Valid values are `STRING`, `STRING_LIST`. Not support `SECURE_STRING`."
  }
}

variable "data_type" {
  description = "(Optional) The default data type of parameters in the parameter set. Only required when `type` is `STRING`. This is only used when a specific data type of the parameter is not provided. Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image` for AMI format. Defaults to `text`. `aws:ssm:integration` data_type parameters must be of the type `SECURE_STRING` and the name must start with the prefix `/d9d01087-4a3f-49e0-b0b4-d568d7826553/ssm/integrations/webhook/`."
  type        = string
  default     = "text"
  nullable    = false

  validation {
    condition     = contains(["text", "aws:ssm:integration", "aws:ec2:image"], var.data_type)
    error_message = "Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image`."
  }
}

variable "allowed_pattern" {
  description = "(Optional) The default regular expression used to validate each parameter value in the parameter set. This is only used when a specific pattern for the parameter is not provided. For example, for `STRING` types with values restricted to numbers, you can specify `^d+$`."
  type        = string
  default     = ""
  nullable    = false
}

variable "parameters" {
  description = <<EOF
  (Required) A list of parameters to manage in the parameter set. Each value of `parameters` block as defined below.
    (Required) `name` - The name of the parameter. This is concatenated with the `path` of the parameter set for the id. The name should begin with slash (/) and end without trailing slash.
    (Optional) `description` - The description of the parameter.
    (Optional) `tier` - The parameter tier to assign to the parameter. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`.
    (Optional) `type` - The intended type of the parameter. Valid values are `STRING`, `STRING_LIST`. Not support `SECURE_STRING`.
    (Optional) `data_type` - The data type of the parameter. Only required when `type` is `STRING`. Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image` for AMI format.
    (Optional) `allowed_pattern` - A regular expression used to validate the parameter value.
    (Required) `value` - The value of the parameter.
  EOF
  type = list(object({
    name            = string
    description     = optional(string)
    tier            = optional(string)
    type            = optional(string)
    data_type       = optional(string)
    allowed_pattern = optional(string)
    value           = string
  }))
  nullable = false

  validation {
    condition = alltrue([
      for parameter in var.parameters :
      alltrue([
        substr(parameter.name, 0, 1) == "/",
        substr(parameter.name, -1, 0) != "/",
      ])
    ])
    error_message = "The name should begin with slash (/) and end without trailing slash."
  }

  validation {
    condition = alltrue([
      for parameter in var.parameters :
      contains(["STANDARD", "ADVANCED", "INTELLIGENT_TIERING"], parameter.tier)
      if parameter.tier != null
    ])
    error_message = "Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`."
  }

  validation {
    condition = alltrue([
      for parameter in var.parameters :
      contains(["STRING", "STRING_LIST"], parameter.type)
      if parameter.type != null
    ])
    error_message = "Valid values are `STRING`, `STRING_LIST`. Not support `SECURE_STRING`."
  }

  validation {
    condition = alltrue([
      for parameter in var.parameters :
      contains(["text", "aws:ssm:integration", "aws:ec2:image"], parameter.data_type)
      if parameter.data_type != null
    ])
    error_message = "Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image`."
  }
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
