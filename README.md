# terraform-aws-secret

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-secret?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-secret?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates secret related resources on AWS.


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-secret) were written to manage the following AWS Services with Terraform.

- **KMS (Key Management Service)**
  - CMK (Customer Master Key)
  - Key Alias
  - Grant (Comming soon!)
- **Secrets Manager**
  - Secret
  - Secret Versions
  - Resource Policy for Secret
  - Configuration for Secret Rotation
- **SSM Parameter Store**
  - Parameters
  - Service Settings


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-secret). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2022-2023, [Byungjin Park](https://www.posquit0.com).
