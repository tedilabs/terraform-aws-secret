provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


###################################################
# Parameter on SSM Parameter Store
###################################################

module "ami" {
  source = "../../modules/ssm-parameter-store-parameter"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter"
  # version = "~> 0.3.0"

  name        = "/ami/ubuntu/22.04"
  description = "Managed by Terraform."
  tier        = "STANDARD"

  type      = "STRING"
  data_type = "aws:ec2:image"

  value = data.aws_ami.ubuntu.image_id

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
