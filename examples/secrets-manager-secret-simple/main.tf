provider "aws" {
  region = "us-east-1"
}


###################################################
# Secrets Manager Secret
###################################################

module "secret" {
  source = "../../modules/secrets-manager-secret"
  # source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  # version = "~> 0.2.0"

  name        = "app/secrets-manager-secret/simple"
  description = "Managed by Terraform."

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
