# ssm-parameter-store-parameter

This module creates following resources.

- `aws_ssm_parameter`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.19.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Friendly name of the new parameter. If the name contains a path (e.g., any forward slashes (/)), it must be fully qualified with a leading forward slash (/). | `string` | n/a | yes |
| <a name="input_allowed_pattern"></a> [allowed\_pattern](#input\_allowed\_pattern) | (Optional) A regular expression used to validate the parameter value. For example, for `STRING` types with values restricted to numbers, you can specify `^d+$`. | `string` | `""` | no |
| <a name="input_data_type"></a> [data\_type](#input\_data\_type) | (Optional) The data type of the parameter. Only required when `type` is `STRING`. Valid values are `text`, `aws:ec2:image` for AMI format. Defaults to `text`. | `string` | `"text"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the parameter. | `string` | `"Managed by Terraform."` | no |
| <a name="input_ignore_value_changes"></a> [ignore\_value\_changes](#input\_ignore\_value\_changes) | (Optional) Whether to manage the parameter value with Terraform. Ignore changes of `value` or `secret_value` if true. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | (Optional) The ARN or ID of the AWS KMS key to be used to encrypt the parameter value with `SECURE_STRING` type. If you don't specify this value, then Parameter Store defaults to using the AWS account's default KMS key named `aws/ssm`. If the default KMS key with that name doesn't yet exist, then AWS Parameter Store creates it for you automatically the first time. | `string` | `null` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_secret_value"></a> [secret\_value](#input\_secret\_value) | (Required) The secure value of the parameter. This argument is valid with a type of `SECURE_STRING` | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | (Optional) The parameter tier to assign to the parameter. If not specified, will use the default parameter tier for the region. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`. | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The intended type of the parameter. Valid values are `STRING`, `STRING_LIST` or `SECURE_STRING`. Defaults to `STRING`. | `string` | `"STRING"` | no |
| <a name="input_value"></a> [value](#input\_value) | (Required) The value of the parameter. This argument is not valid with a type of `SECURE_STRING` | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_allowed_pattern"></a> [allowed\_pattern](#output\_allowed\_pattern) | The regular expression used to validate the parameter value. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the parameter. |
| <a name="output_data_type"></a> [data\_type](#output\_data\_type) | The data type of the parameter. Only required when `type` is `STRING`. |
| <a name="output_description"></a> [description](#output\_description) | The description of the parameter. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the parameter. |
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | The ARN or ID of the AWS KMS key which is used to encrypt the parameter value. |
| <a name="output_name"></a> [name](#output\_name) | The name of the parameter. |
| <a name="output_secret_value"></a> [secret\_value](#output\_secret\_value) | The secure value of the parameter. argument is valid with a type of `SECURE_STRING`. |
| <a name="output_tier"></a> [tier](#output\_tier) | The tier of the parameter. |
| <a name="output_type"></a> [type](#output\_type) | The type of the parameter. |
| <a name="output_value"></a> [value](#output\_value) | The value of the parameter. argument is not valid with a type of `SECURE_STRING`. |
| <a name="output_version"></a> [version](#output\_version) | The current version of the parameter. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
