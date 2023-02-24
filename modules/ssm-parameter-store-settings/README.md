# ssm-parameter-store-settings

This module creates following resources.

- `aws_ssm_service_setting`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_service_setting.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_service_setting) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_parameter_tier"></a> [default\_parameter\_tier](#input\_default\_parameter\_tier) | (Optional) The parameter tier to use by default when a request to create or update a parameter does not specify a tier. The intended type of the secret. Valid values are `STANDARD`, `ADVANCED` or `INTELLIGENT_TIERING`. Defaults to `STANDARD`. | `string` | `"STANDARD"` | no |
| <a name="input_high_throughput_enabled"></a> [high\_throughput\_enabled](#input\_high\_throughput\_enabled) | (Optional) Whether to increase Parameter Store throughput. Defaults to `false`. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_parameter_tier"></a> [default\_parameter\_tier](#output\_default\_parameter\_tier) | The parameter tier to use by default when a request to create or update a parameter does not specify a tier. |
| <a name="output_high_throughput_enabled"></a> [high\_throughput\_enabled](#output\_high\_throughput\_enabled) | Whether to increase Parameter Store throughput. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
