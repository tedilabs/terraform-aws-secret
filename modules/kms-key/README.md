# kms-key

This module creates following resources.

- `aws_kms_key`
- `aws_kms_key_policy` (optional)
- `aws_kms_alias` (optional)
- `aws_kms_grant` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_grant.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_iam_policy_document.predefined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

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
| <a name="input_grants"></a> [grants](#input\_grants) | (Optional) A list of grants configuration for granting access to the KMS key. Each item of `grants` as defined below.<br/>    (Required) `name` - A friendly name for the grant.<br/>    (Required) `grantee_principal` - The principal that is given permission to perform the operations that the grant permits in ARN format.<br/>    (Required) `operations` - A set of operations that the grant permits. Valid values are `Encrypt`, `Decrypt`, `GenerateDataKey`, `GenerateDataKeyWithoutPlaintext`, `ReEncryptFrom`, `ReEncryptTo`, `CreateGrant`, `RetireGrant`, `DescribeKey`, `GenerateDataKeyPair`, `GenerateDataKeyPairWithoutPlaintext`, `GetPublicKey`, `Sign`, `Verify`, `GenerateMac`, `VerifyMac`, or `DeriveSharedSecret`.<br/>    (Optional) `retiring_principal` - The principal that is given permission to retire the grant by using RetireGrant operation in ARN format.<br/>    (Optional) `retire_on_delete` - Whether to retire the grant upon deletion. Defaults to `false`.<br/>      Retire: Grantee returns permissions voluntarily (normal termination)<br/>      Revoke: Admin forcefully cancels permissions (emergency termination)<br/>    (Optional) `grant_creation_tokens` - A list of grant tokens to be used when creating the grant. Use grant token for immediate access without waiting for grant propagation (up to 5 min). Required for time-sensitive operations.<br/>    (Optional) `constraints` - A configuration for grant constraints. `constraints` block as defined below.<br/>      (Optional) `type` - The type of constraints. Valid values are `ENCRYPTION_CONTEXT_EQUALS` or `ENCRYPTION_CONTEXT_SUBSET`. Defaults to `ENCRYPTION_CONTEXT_SUBSET`.<br/>      (Optional) `value` - A map of key-value pair to be validated against the encryption context during cryptographic operations. | <pre>list(object({<br/>    name              = string<br/>    grantee_principal = string<br/>    operations        = set(string)<br/><br/>    retiring_principal    = optional(string)<br/>    retire_on_delete      = optional(bool, false)<br/>    grant_creation_tokens = optional(list(string))<br/><br/>    constraints = optional(object({<br/>      type  = optional(string, "ENCRYPTION_CONTEXT_SUBSET")<br/>      value = map(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_key_rotation"></a> [key\_rotation](#input\_key\_rotation) | (Optional) A configuration for key rotation of the KMS key. This configuration is only applicable for symmetric encryption KMS keys. `key_rotation` block as defined below.<br/>    (Optional) `enabled` - Whether key rotation is enabled. Defaults to `false`.<br/>    (Optional) `period_in_days` - The custom period of t ime between each key rotation. Valid value is between `90` and `2560` days (inclusive). Defaults to `365`. | <pre>object({<br/>    enabled        = optional(bool, false)<br/>    period_in_days = optional(number, 365)<br/>  })</pre> | `{}` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_multi_region_enabled"></a> [multi\_region\_enabled](#input\_multi\_region\_enabled) | (Optional) Indicates whether the key is a multi-Region (true) or regional (false) key. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A valid policy JSON document. Although this is a key policy, not an IAM policy, an `aws_iam_policy_document`, in the form that designates a principal, can be used. | `string` | `null` | no |
| <a name="input_predefined_roles"></a> [predefined\_roles](#input\_predefined\_roles) | (Optional) A configuration for predefined roles of the KMS key. This configuration will be merged with given `policy` if it is defined. `predefined_roles` block as defined below.<br/>    (Optional) `owners` - A set of AWS principals that are allowed to perform all key operations.<br/>    (Optional) `administrators` - A set of AWS principals that are allowed to perform all key administrative operations.<br/>    (Optional) `users` - A set of AWS principals that are allowed to use the key for encryption and decryption operations.<br/>    (Optional) `service_users` - A set of AWS principals that are allowed to use the key for service integration operations.<br/>    (Optional) `symmetric_encryption` - A set of AWS principals that are allowed to use the key for symmetric encryption operations.<br/>    (Optional) `asymmetric_encryption` - A set of AWS principals that are allowed to use the key for asymmetric encryption operations.<br/>    (Optional) `asymmetric_signing` - A set of AWS principals that are allowed to use the key for asymmetric signing operations.<br/>    (Optional) `hmac` - A set of AWS principals that are allowed to use the key for HMAC operations. | <pre>object({<br/>    owners         = optional(set(string), [])<br/>    administrators = optional(set(string), [])<br/>    users          = optional(set(string), [])<br/>    service_users  = optional(set(string), [])<br/><br/>    symmetric_encryption  = optional(set(string), [])<br/>    asymmetric_encryption = optional(set(string), [])<br/>    asymmetric_signing    = optional(set(string), [])<br/>    hmac                  = optional(set(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_spec"></a> [spec](#input\_spec) | (Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_224`, `HMAC_256`, `HMAC_384`, `HMAC_512`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, `ECC_SECG_P256K1`, `ML_DSA_44`, `ML_DSA_65`, `ML_DSA_87`, or `SM2` (China Regions Only). Defaults to `SYMMETRIC_DEFAULT`. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_usage"></a> [usage](#input\_usage) | (Optional) Specifies the intended use of the key. Valid values are `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, `GENERATE_VERIFY_MAC`, `KEY_AGREEMENT`. Defaults to `ENCRYPT_DECRYPT`. | `string` | `"ENCRYPT_DECRYPT"` | no |
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
| <a name="output_grants"></a> [grants](#output\_grants) | A collection of grants for the key. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the KMS key. |
| <a name="output_key_rotation"></a> [key\_rotation](#output\_key\_rotation) | The key rotation configuration of the KMS key. |
| <a name="output_multi_region_enabled"></a> [multi\_region\_enabled](#output\_multi\_region\_enabled) | Whether the key is a multi-region key. |
| <a name="output_name"></a> [name](#output\_name) | The KMS Key name. |
| <a name="output_policy"></a> [policy](#output\_policy) | The Resource Policy for KMS Key. |
| <a name="output_predefined_roles"></a> [predefined\_roles](#output\_predefined\_roles) | The predefined roles that have access to the KMS key. |
| <a name="output_spec"></a> [spec](#output\_spec) | The specification of KMS key which is the encryption algorithm or signing algorithm. |
| <a name="output_usage"></a> [usage](#output\_usage) | The usage of the KMS key. |
| <a name="output_xks_key"></a> [xks\_key](#output\_xks\_key) | The ID of the external key that serves as key material for the KMS key in an external key store. |
<!-- END_TF_DOCS -->
