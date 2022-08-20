variable "default_parameter_tier" {
  description = "(Optional) The parameter tier to use by default when a request to create or update a parameter does not specify a tier. The intended type of the secret. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`. Defaults to `STANDARD`."
  type        = string
  default     = "STANDARD"
  nullable    = false

  validation {
    condition     = contains(["STANDARD", "ADVANCED", "INTELLIGENT_TIERING"], var.default_parameter_tier)
    error_message = "Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`."
  }
}

variable "high_throughput_enabled" {
  description = "(Optional) Whether to increase Parameter Store throughput. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}
