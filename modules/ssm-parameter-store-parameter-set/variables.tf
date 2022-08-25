variable "path" {
  description = "(Required) A path used for the prefix of each parameter name created by this parameter set. The path should begin with slash (/) and end without trailing slash."
  type        = string

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
  description = "(Optional) The default data type of parameters in the parameter set. Only required when `type` is `STRING`. This is only used when a specific data type of the parameter is not provided. Valid values are `text`, `aws:ec2:image` for AMI format. Defaults to `text`."
  type        = string
  default     = "text"
  nullable    = false

  validation {
    condition     = contains(["text", "aws:ec2:image"], var.data_type)
    error_message = "Valid values are `text`, `aws:ec2:image`."
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
    (Optional) `data_type` - The data type of the parameter. Only required when `type` is `STRING`. Valid values are `text`, `aws:ec2:image` for AMI format.
    (Optional) `allowed_pattern` - A regular expression used to validate the parameter value.
    (Required) `value` - The value of the parameter.
  EOF
  type        = list(map(string))
  nullable    = false

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
      if try(parameter.tier, null) != null
    ])
    error_message = "Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`."
  }

  validation {
    condition = alltrue([
      for parameter in var.parameters :
      contains(["STRING", "STRING_LIST"], parameter.type)
      if try(parameter.type, null) != null
    ])
    error_message = "Valid values are `STRING`, `STRING_LIST`. Not support `SECURE_STRING`."
  }

  validation {
    condition = alltrue([
      for parameter in var.parameters :
      contains(["text", "aws:ec2:image"], parameter.data_type)
      if try(parameter.data_type, null) != null
    ])
    error_message = "Valid values are `text`, `aws:ec2:image`."
  }

  validation {
    condition = alltrue([
      for parameter in var.parameters :
      can(parameter.value)
    ])
    error_message = "The value for `value` is required."
  }
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
