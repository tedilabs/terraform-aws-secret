provider "aws" {
  region = "us-east-1"
}


###################################################
# Secrets Manager Secret
###################################################

module "secret__text" {
  source = "../../modules/secrets-manager-secret"
  # source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  # version = "~> 0.3.0"

  name        = "app/secrets-manager-secret/value/text"
  description = "Managed by Terraform."

  type  = "TEXT"
  value = "this_is_the_secret"

  deletion_window_in_days = 7

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "secret__kv" {
  source = "../../modules/secrets-manager-secret"
  # source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  # version = "~> 0.3.0"

  name        = "app/secrets-manager-secret/value/kv"
  description = "Managed by Terraform."

  type = "KEY_VALUE"
  value = {
    a = "foo"
    b = "bar"
    c = "foobar"
  }

  deletion_window_in_days = 7

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}

module "secret__binary" {
  source = "../../modules/secrets-manager-secret"
  # source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  # version = "~> 0.3.0"

  name        = "app/secrets-manager-secret/value/binary"
  description = "Managed by Terraform."

  type  = "BINARY"
  value = filebase64("${path.module}/files/binary")

  deletion_window_in_days = 7

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
