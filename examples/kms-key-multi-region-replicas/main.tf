provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "this" {}
locals {
  account_id = data.aws_caller_identity.this.id
}


###################################################
# KMS Key
###################################################

module "key" {
  source = "../../modules/kms-key"
  # source  = "tedilabs/secret/aws//modules/kms-key"
  # version = "~> 0.3.0"

  region = "us-east-1"

  name                    = "example"
  description             = "Managed by Terraform."
  enabled                 = true
  deletion_window_in_days = 7
  multi_region_enabled    = true

  usage = "ENCRYPT_DECRYPT"
  spec  = "SYMMETRIC_DEFAULT"

  key_rotation = {
    enabled = true
  }

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}


###################################################
# Replicas of KMS Key
###################################################

module "replica" {
  source = "../../modules/kms-replica-key"
  # source  = "tedilabs/secret/aws//modules/kms-replica-key"
  # version = "~> 0.3.0"

  for_each = toset(["ap-northeast-1", "ap-northeast-2"])

  region = each.value

  primary_key = module.key.arn

  name                    = "example-replica-${each.value}"
  description             = "Managed by Terraform."
  enabled                 = true
  deletion_window_in_days = 7

  aliases = [
    "alias/test"
  ]

  predefined_policies = [
    {
      role         = "OWNER"
      iam_entities = ["arn:aws:iam::${local.account_id}:root"]
    }
  ]
  grants = [
    {
      name              = "example"
      grantee_principal = "arn:aws:iam::${local.account_id}:root"
      operations        = ["Decrypt", "Encrypt", "GenerateDataKey"]
    }
  ]

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
