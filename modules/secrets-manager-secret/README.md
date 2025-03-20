# secrets-manager-secret

This module creates following resources.

- `aws_secretsmanager_secret`
- `aws_secretsmanager_secret_policy` (optional)
- `aws_secretsmanager_secret_rotation` (optional)
- `aws_secretsmanager_secret_version` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.43 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_rotation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.versions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: `/_+=.@-`. | `string` | n/a | yes |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | (Optional) Whether to reject calls to PUT a resource policy if the policy allows public access. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | (Optional) Duration in days after which the secret is deleted after destruction of the resource. Valid value is between `7` and `30` days. Defaults to `30`. | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the secret. | `string` | `"Managed by Terraform."` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | (Optional) The ARN or Id of the AWS KMS key to be used to encrypt the secret values in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key named `aws/secretsmanager`. If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time. | `string` | `null` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_overwrite_in_replicas"></a> [overwrite\_in\_replicas](#input\_overwrite\_in\_replicas) | (Optional) Whether to overwrite a secret with the same name in the destination region during replication. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A valid JSON document representing a resource policy. | `string` | `null` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | (Optional) A list of replica configurations of the Secrets Manager secret. Each value of `replicas` block as defined below.<br>    (Required) `region` - The region for replicating the secret.<br>    (Optional) `kms_key` - The ARN, Key ID, or Alias of the AWS KMS key within the region secret is replicated to. If one is not specified, then Secrets Manager defaults to using the AWS account's default KMS key named `aws/secretsmanager` in the region. If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time. | <pre>list(object({<br>    region  = string<br>    kms_key = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_rotation"></a> [rotation](#input\_rotation) | (Optional) A rotation configurations of the Secrets Manager secret. `rotation` block as defined below.<br>    (Optional) `enabled` - Whether to enable automatic rotation of the secret. Defaults to `false`.<br>    (Optionial) `rotate_immediately` - Whether to rotate the secret immediately or wait until the next scheduled rotation window. The rotation schedule is defined in rotation\_rules. For secrets that use a Lambda rotation function to rotate, if you don't immediately rotate the secret, Secrets Manager tests the rotation configuration by running the testSecret step. Defaults to `true`.<br>    (Optional) `lambda_function` - The ARN of the Lambda function that can rotate the secret.<br>    (Optional) `schedule_frequency` - The number of days between automatic scheduled rotations of the secret. Either `schedule_frequency` or `schedule_expression` must be specified.<br>    (Optional) `schedule_expression` - A cron expression such as `cron(a b c d e f)` or a rate expression such as `rate(10 days)`. Either `schedule_frequency` or `schedule_expression` must be specified.<br>    (Optional) `duration` - The length of the rotation window in hours. | <pre>object({<br>    enabled             = optional(bool, false)<br>    rotate_immediately  = optional(bool, true)<br>    lambda_function     = optional(string)<br>    schedule_frequency  = optional(number)<br>    schedule_expression = optional(string)<br>    duration            = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The intended type of the secret. Valid values are `TEXT`, `KEY_VALUE` or `BINARY`. | `string` | `"KEY_VALUE"` | no |
| <a name="input_value"></a> [value](#input\_value) | (Optional) The secret value that you want to encrypt and store in the current version of the secret. Specify plaintext data with `string` type if `type` is `TEXT`. Specify key-value data with `map` type if `type` is `KEY_VALUE`. Specify binary data with `string` type if `type` is `BINARY`. The `aws_secretsmanager_secret_version` resource is deleted from Terraform if you set the value to `null`. However, `AWSCURRENT` staging label is still active on the version event after the resource is deleted from Terraform. | `any` | `null` | no |
| <a name="input_versions"></a> [versions](#input\_versions) | (Optional) A list of versions other than `AWSCURRENT` version of the Secrets Manager secret. Each value of `versions` block as defined below.<br>    (Required) `value` - The secret value that you want to encrypyt and store in this version of the secret. Specify plaintext data with `string` type if `type` is `TEXT`. Specify key-value data with `map` type if `type` is `KEY_VALUE`. Specify binary data with `string` type if `type` is `BINARY`.<br>    (Required) `labels` - A list of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret. If you specify a staging label that's already associated with a different version of the same secret then that staging label is automatically removed from the other version and attached to this version. | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the Secrets Manager secret. |
| <a name="output_deletion_window_in_days"></a> [deletion\_window\_in\_days](#output\_deletion\_window\_in\_days) | Duration in days after which the secret is deleted after destruction of the resource. |
| <a name="output_description"></a> [description](#output\_description) | The description of the secret. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Secrets Manager secret. |
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | The ARN or Id of the AWS KMS key which is used to encrypt the secret values in this secret. |
| <a name="output_name"></a> [name](#output\_name) | The name of the secret. |
| <a name="output_overwrite_in_replicas"></a> [overwrite\_in\_replicas](#output\_overwrite\_in\_replicas) | Whether to overwrite a secret with the same name in the destination region during replication. |
| <a name="output_policy"></a> [policy](#output\_policy) | The Resource Policy for the secret. |
| <a name="output_replicas"></a> [replicas](#output\_replicas) | The information for regional replications of the secret. |
| <a name="output_rotation"></a> [rotation](#output\_rotation) | The configuration of the automatic rotation for the secret. |
| <a name="output_type"></a> [type](#output\_type) | The type of the secret. |
| <a name="output_value"></a> [value](#output\_value) | The secret value in the current version of the secret with `AWSCURRENT` staging label. |
| <a name="output_versions"></a> [versions](#output\_versions) | A list of versions other than the current version of the secret. |
<!-- END_TF_DOCS -->
