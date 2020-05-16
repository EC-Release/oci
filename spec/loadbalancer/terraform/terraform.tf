provider "aws" {
  profile = "digital-connect-aws/bu-ec-admin" /*Cago profile name for connecting to AWS through CLI*/
  region  = "us-east-1" /*Specify the region*/
}

resource "aws_instance" "dc-terraform-demo" {
  ami                  = "ami-09a5b0b7edf08843d" /*Define the AMI you want to install*/
  instance_type        = "t2.micro" /*Your machine*/
  subnet_id            = "subnet-abcdefgh" /*Subnet you want the instance to reside*/
  security_groups      = ["sg-abcdefgh"] /*Existing Securuty Group*/
  key_name             = "key_pair" /*Choose existing key pair*/
  iam_instance_profile = "dc-ssm-session-manager-iam" /*Choose a profile, that has connectivity to SSM*/
  associate_public_ip_address = false
  user_data            = "${file("install-lber-packages.sh")}"
  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = "dc-project_name-more_info" /*Name of your project*/
    Env            = "Lab" /*Environment*/
    Engineer_Email = "your.name@ge.com" /*Your Email Address*/
    Engineer_SSO   = "12345678" /*Your SSO Number*/
    Best_By        = "2020-05-30" /*If this is temporary instance*/
    UAI            = "UAI1234567" /*Your Application UAI number if exists*/
    Builder        = "Terraform"
  }
}
