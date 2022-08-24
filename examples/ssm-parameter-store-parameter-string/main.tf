provider "aws" {
  region = "us-east-1"
}


###################################################
# Parameter on SSM Parameter Store
###################################################

module "standard" {
  source = "../../modules/ssm-parameter-store-parameter"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter"
  # version = "~> 0.3.0"

  name        = "/example/standard"
  description = "Managed by Terraform."
  tier        = "STANDARD"

  value = "This is example."

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "advanced" {
  source = "../../modules/ssm-parameter-store-parameter"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter"
  # version = "~> 0.3.0"

  name        = "/example/advanced"
  description = "Managed by Terraform."
  tier        = "ADVANCED"

  value = file("${path.module}/bigfile")

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "intelligent" {
  source = "../../modules/ssm-parameter-store-parameter"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter"
  # version = "~> 0.3.0"

  name        = "/example/intelligent"
  description = "Managed by Terraform."
  tier        = "INTELLIGENT_TIERING"

  value = file("${path.module}/bigfile")

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
