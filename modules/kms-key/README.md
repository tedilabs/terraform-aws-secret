# kms-key

This module creates following resources.

- `aws_kms_key`
- `aws_kms_key_policy` (optional)
- `aws_kms_alias` (optional)
- `aws_kms_grant` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the KMS key. | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | (Optional) A set of display name of the alias. The name must start with the word `alias/`. | `set(string)` | `[]` | no |
| <a name="input_bypass_policy_lockout_safety_check"></a> [bypass\_policy\_lockout\_safety\_check](#input\_bypass\_policy\_lockout\_safety\_check) | (Optional) Whether to bypass the key policy lockout safety check performed when creating or updating the key's policy. Setting this value to true increases the risk that the CMK becomes unmanageable. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_custom_key_store"></a> [custom\_key\_store](#input\_custom\_key\_store) | (Optional) The ID of the KMS Custom Key Store where the key will be stored instead of KMS. This parameter is valid only for symmetric encryption KMS keys in a single region. | `string` | `null` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | (Optional) Duration in days after which the key is deleted after destruction of the resource. Valid value is between `7` and `30` days. Defaults to `30`. | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the KMS key. | `string` | `"Managed by Terraform."` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Indicates whether the key is enabled. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_key_rotation_enabled"></a> [key\_rotation\_enabled](#input\_key\_rotation\_enabled) | (Optional) Indicates whether key rotation is enabled. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_multi_region_enabled"></a> [multi\_region\_enabled](#input\_multi\_region\_enabled) | (Optional) Indicates whether the key is a multi-Region (true) or regional (false) key. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A valid policy JSON document. Although this is a key policy, not an IAM policy, an `aws_iam_policy_document`, in the form that designates a principal, can be used. | `string` | `null` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_spec"></a> [spec](#input\_spec) | (Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT`. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_usage"></a> [usage](#input\_usage) | (Optional) Specifies the intended use of the key. Valid values are `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, or `GENERATE_VERIFY_MAC`. Defaults to `ENCRYPT_DECRYPT`. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_xks_key"></a> [xks\_key](#input\_xks\_key) | (Optional) The ID of the external key that serves as key material for the KMS key in an external key store. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aliases"></a> [aliases](#output\_aliases) | A collection of aliases of the key. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the KMS key. |
| <a name="output_custom_key_store"></a> [custom\_key\_store](#output\_custom\_key\_store) | The ID of the KMS Custom Key Store where the key will be stored instead of KMS. |
| <a name="output_deletion_window_in_days"></a> [deletion\_window\_in\_days](#output\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource. |
| <a name="output_description"></a> [description](#output\_description) | The description of the KMS key. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the key is enabled. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the KMS key. |
| <a name="output_key_rotation_enabled"></a> [key\_rotation\_enabled](#output\_key\_rotation\_enabled) | Whether the key rotation is enabled. |
| <a name="output_multi_region_enabled"></a> [multi\_region\_enabled](#output\_multi\_region\_enabled) | Whether the key is a multi-region key. |
| <a name="output_name"></a> [name](#output\_name) | The KMS Key name. |
| <a name="output_policy"></a> [policy](#output\_policy) | The Resource Policy for KMS Key. |
| <a name="output_spec"></a> [spec](#output\_spec) | The specification of KMS key which is the encryption algorithm or signing algorithm. |
| <a name="output_usage"></a> [usage](#output\_usage) | The usage of the KMS key. |
| <a name="output_xks_key"></a> [xks\_key](#output\_xks\_key) | The ID of the external key that serves as key material for the KMS key in an external key store. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
