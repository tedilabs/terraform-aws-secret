provider "aws" {
  region = "us-east-1"
}


###################################################
# Secrets Manager Secret
###################################################

module "secret__text" {
  source = "../../modules/secrets-manager-secret"
  # source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  # version = "~> 0.2.0"

  name        = "app/secrets-manager-secret/version/text"
  description = "Managed by Terraform."

  type  = "TEXT"
  value = "this_is_the_secret"
  versions = [
    {
      value  = "this_is_staging_secret"
      labels = ["staging"]
    },
    {
      value  = "this_is_dev_secret"
      labels = ["dev"]
    }
  ]

  deletion_window_in_days = 7

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "secret__kv" {
  source = "../../modules/secrets-manager-secret"
  # source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  # version = "~> 0.2.0"

  name        = "app/secrets-manager-secret/version/kv"
  description = "Managed by Terraform."

  type = "KEY_VALUE"
  value = {
    env    = "prod"
    secret = "foo"
  }
  versions = [
    {
      value = {
        env    = "staging"
        secret = "bar"
      }
      labels = ["staging"]
    },
    {
      value = {
        env    = "dev"
        secret = "foobar"
      }
      labels = ["dev"]
    }
  ]

  deletion_window_in_days = 7

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "secret__binary" {
  source = "../../modules/secrets-manager-secret"
  # source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  # version = "~> 0.2.0"

  name        = "app/secrets-manager-secret/version/binary"
  description = "Managed by Terraform."

  type  = "BINARY"
  value = filebase64("${path.module}/files/binary")
  versions = [
    {
      value  = filebase64("${path.module}/files/binary2")
      labels = ["staging"]
    },
  ]

  deletion_window_in_days = 7

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
