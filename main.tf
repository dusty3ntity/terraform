provider "aws" {
  region = "eu-north-1"
}

locals {
  key_name = "vohyr-key"
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Lab05-Ohyr-edited"

  instance_type               = var.instance_type
  key_name                    = module.key_pair.key_pair_name
  monitoring                  = true
  ami                         = data.aws_ami.ubuntu.id
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.selected.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = local.key_name
  create_private_key = true
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "Ohyr-SG"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}
