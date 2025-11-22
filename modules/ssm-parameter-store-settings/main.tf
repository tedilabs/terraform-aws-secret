locals {
  metadata = {
    package = "terraform-aws-secret"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = local.region
  }
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {
  region = var.region
}

locals {
  account_id = data.aws_caller_identity.this.account_id
  region     = data.aws_region.this.region

  parameter_tiers = {
    "STANDARD"            = "Standard"
    "ADVANCED"            = "Advanced"
    "INTELLIGENT_TIERING" = "Intelligent-Tiering"
  }

  setting_id_prefix = "arn:aws:ssm:${local.region}:${local.account_id}:servicesetting/ssm/parameter-store"
  settings = {
    "default-parameter-tier"  = local.parameter_tiers[var.default_parameter_tier]
    "high-throughput-enabled" = var.high_throughput_enabled ? "true" : "false"
  }
}


###################################################
# Settings for Parameter Store on SSM (Systems Manager)
###################################################

resource "aws_ssm_service_setting" "this" {
  for_each = local.settings

  region = var.region

  setting_id    = "${local.setting_id_prefix}/${each.key}"
  setting_value = each.value
}
