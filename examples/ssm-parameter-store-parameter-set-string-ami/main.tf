provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu_bionic" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu_focal" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu_jammy" {
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
  source = "../../modules/ssm-parameter-store-parameter-set"
  # source  = "tedilabs/secret/aws//modules/ssm-parameter-store-parameter-set"
  # version = "~> 0.3.0"

  path = "/ami/ubuntu"
  parameters = [
    {
      name  = "/18.04"
      value = data.aws_ami.ubuntu_bionic.image_id
    },
    {
      name  = "/20.04"
      value = data.aws_ami.ubuntu_focal.image_id
    },
    {
      name  = "/22.04"
      value = data.aws_ami.ubuntu_jammy.image_id
    },
  ]

  ## Default values
  tier      = "STANDARD"
  type      = "STRING"
  data_type = "aws:ec2:image"

  tags = {
    "project" = "terraform-aws-secret-examples"
  }
}
