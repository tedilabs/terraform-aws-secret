provider "aws" {
  region = "us-east-1"
}

locals {
  big = file("${path.module}/bigfile")
}

###################################################
# Parameter on SSM Parameter Store
###################################################

module "standard" {
  source = "../../modules/ssm-parameter-store-parameter"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter"
  # version = "~> 0.3.0"

  name        = "/example/string-list/standard"
  description = "Managed by Terraform."
  tier        = "STANDARD"

  type = "STRING_LIST"

  value = "A,B,C"

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "advanced" {
  source = "../../modules/ssm-parameter-store-parameter"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter"
  # version = "~> 0.3.0"

  name        = "/example/string-list/advanced"
  description = "Managed by Terraform."
  tier        = "ADVANCED"

  type = "STRING_LIST"

  value = local.big

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "intelligent" {
  source = "../../modules/ssm-parameter-store-parameter"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter"
  # version = "~> 0.3.0"

  name        = "/example/string-list/intelligent"
  description = "Managed by Terraform."
  tier        = "INTELLIGENT_TIERING"

  value = join(",", ["ABCD", "12345", "zxcv"])

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
