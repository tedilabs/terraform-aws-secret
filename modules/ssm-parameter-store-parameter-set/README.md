# ssm-parameter-store-parameter-set

This module creates following resources.

- `aws_ssm_parameter`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |
| <a name="requirement_telemetry"></a> [telemetry](#requirement\_telemetry) | >= 0.2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |
| <a name="module_this"></a> [this](#module\_this) | ../ssm-parameter-store-parameter | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | (Required) A list of parameters to manage in the parameter set. Each value of `parameters` block as defined below.<br/>    (Required) `name` - The name of the parameter. This is concatenated with the `path` of the parameter set for the id. The name should begin with slash (/) and end without trailing slash.<br/>    (Optional) `description` - The description of the parameter.<br/>    (Optional) `tier` - The parameter tier to assign to the parameter. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`.<br/>    (Optional) `type` - The intended type of the parameter. Valid values are `STRING`, `STRING_LIST`. Not support `SECURE_STRING`.<br/>    (Optional) `data_type` - The data type of the parameter. Only required when `type` is `STRING`. Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image` for AMI format.<br/>    (Optional) `allowed_pattern` - A regular expression used to validate the parameter value.<br/>    (Required) `value` - The value of the parameter. | <pre>list(object({<br/>    name            = string<br/>    description     = optional(string)<br/>    tier            = optional(string)<br/>    type            = optional(string)<br/>    data_type       = optional(string)<br/>    allowed_pattern = optional(string)<br/>    value           = string<br/>  }))</pre> | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | (Required) A path used for the prefix of each parameter name created by this parameter set. The path should begin with slash (/) and end without trailing slash. | `string` | n/a | yes |
| <a name="input_allowed_pattern"></a> [allowed\_pattern](#input\_allowed\_pattern) | (Optional) The default regular expression used to validate each parameter value in the parameter set. This is only used when a specific pattern for the parameter is not provided. For example, for `STRING` types with values restricted to numbers, you can specify `^d+$`. | `string` | `""` | no |
| <a name="input_data_type"></a> [data\_type](#input\_data\_type) | (Optional) The default data type of parameters in the parameter set. Only required when `type` is `STRING`. This is only used when a specific data type of the parameter is not provided. Valid values are `text`, `aws:ssm:integration`, `aws:ec2:image` for AMI format. Defaults to `text`. `aws:ssm:integration` data\_type parameters must be of the type `SECURE_STRING` and the name must start with the prefix `/d9d01087-4a3f-49e0-b0b4-d568d7826553/ssm/integrations/webhook/`. | `string` | `"text"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The default description of parameters in the parameter set. This is only used when a specific description of the parameter is not provided. | `string` | `"Managed by Terraform."` | no |
| <a name="input_ignore_value_changes"></a> [ignore\_value\_changes](#input\_ignore\_value\_changes) | (Optional) Whether to manage the parameter value with Terraform. Ignore changes of `value` or `secret_value` if true. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_telemetry"></a> [telemetry](#input\_telemetry) | (Optional) A configuration to collect telemetry data for the module. This is used to improve the module and its features. To send pseudonyms instead of identifying values such as the hostname and the Git remote, set `pseudonymization_enabled` to `true`. Pseudonyms are not anonymous; to keep data from being sent, disable its collector. The default configuration enables telemetry collection for machine, network, git, github, github actions, HCP Terraform, terraform, and toolchain. You can disable telemetry collection by setting `enabled` to `false`. `telemetry` block as defined below.<br/>    (Optional) `enabled` - Whether to enable telemetry collection. Default is `true`.<br/>    (Optional) `capture_machine` - Whether to capture machine information. Default is `true`.<br/>    (Optional) `capture_network` - Whether to capture network information. Default is `true`.<br/>    (Optional) `capture_git` - Whether to capture git information. Default is `true`.<br/>    (Optional) `capture_github` - Whether to capture GitHub information. Default is `true`.<br/>    (Optional) `capture_github_actions` - Whether to capture GitHub Actions information. Default is `true`.<br/>    (Optional) `capture_hcp_terraform` - Whether to capture HCP Terraform information. Default is `true`.<br/>    (Optional) `capture_terraform` - Whether to capture Terraform information. Default is `true`.<br/>    (Optional) `capture_toolchain` - Whether to capture toolchain information. Default is `true`.<br/>    (Optional) `pseudonymization_enabled` - Whether to enable pseudonymization of the captured data. Default is `false`. | <pre>object({<br/>    enabled = optional(bool, true)<br/><br/>    capture_machine        = optional(bool, true)<br/>    capture_network        = optional(bool, true)<br/>    capture_git            = optional(bool, true)<br/>    capture_github         = optional(bool, true)<br/>    capture_github_actions = optional(bool, true)<br/>    capture_hcp_terraform  = optional(bool, true)<br/>    capture_terraform      = optional(bool, true)<br/>    capture_toolchain      = optional(bool, true)<br/><br/>    pseudonymization_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | (Optional) The default parameter tier to assign to parameters in the parameter set. This is only used when a specific tier of the parameter is not provided. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`. Defaults to `INTELLIGENT_TIERING`. | `string` | `"INTELLIGENT_TIERING"` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The default type of parameters in the parameter set. This is only used when a specific type of the parameter is not provided. Valid values are `STRING`, `STRING_LIST`. Not support `SECURE_STRING`. Defaults to `STRING`. | `string` | `"STRING"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_parameters"></a> [parameters](#output\_parameters) | The list of parameters in the parameter set. |
| <a name="output_path"></a> [path](#output\_path) | The path used for the prefix of each parameter names managed by this parameter set. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
<!-- END_TF_DOCS -->
