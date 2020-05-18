provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_instance" "dc-ec-gateway-lber-vm" {
  ami                         = var.aws_instance_lber.ami
  instance_type               = var.aws_instance_lber.instance_type
  subnet_id                   = var.aws_instance_lber.subnet_id
  security_groups             = var.aws_instance_lber.security_groups
  key_name                    = var.aws_instance_lber.key_name
  iam_instance_profile        = var.aws_instance_lber.iam_instance_profile
  associate_public_ip_address = var.aws_instance_lber.associate_public_ip_address
  user_data                   = "${file("install-lber-packages.sh")}"

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = var.aws_instance_lber.tags.Name
    Env            = var.aws_instance_lber.tags.Env
    Engineer_Email = var.aws_instance_lber.tags.Engineer_Email
    Engineer_SSO   = var.aws_instance_lber.tags.Engineer_SSO
    Best_By        = var.aws_instance_lber.tags.Best_By
    UAI            = var.aws_instance_lber.tags.UAI
    Builder        = var.aws_instance_lber.tags.Builder
  }
}

resource "aws_instance" "dc-ec-gateway-vm" {
  count                       = var.aws_instance_gw.count
  ami                         = var.aws_instance_gw.ami
  instance_type               = var.aws_instance_gw.instance_type
  subnet_id                   = var.aws_instance_gw.subnet_id
  security_groups             = var.aws_instance_gw.security_groups
  key_name                    = var.aws_instance_gw.key_name
  iam_instance_profile        = var.aws_instance_gw.iam_instance_profile
  associate_public_ip_address = var.aws_instance_gw.associate_public_ip_address
  user_data                   = "${file("install-gateway-packages.sh")}"

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = var.aws_instance_gw.tags.Name
    Env            = var.aws_instance_gw.tags.Env
    Engineer_Email = var.aws_instance_gw.tags.Engineer_Email
    Engineer_SSO   = var.aws_instance_gw.tags.Engineer_SSO
    Best_By        = var.aws_instance_gw.tags.Best_By
    UAI            = var.aws_instance_gw.tags.UAI
    Builder        = var.aws_instance_gw.tags.Builder
  }
}