provider "aws" {
  profile = "account-id/role" /*Cago profile name for connecting to AWS through CLI*/
  region  = "region-id-x" /*Specify the region*/
}

resource "aws_instance" "dc-terraform-demo" {
  ami                         = "ami-0915e09cc7ceee3ab" /*Define the AMI you want to install*/
  instance_type               = "t2.micro" /*Your machine*/
  subnet_id                   = "subnet-abcdefgh" /*Subnet you want the instance to reside*/
  security_groups             = ["sg-12345678"] /*Existing Securuty Group*/
  key_name                    = "dc-key-name" /*Choose existing key pair*/
  iam_instance_profile        = "dc-ssm-session-manager-iam" /*Choose a profile, that has connectivity to SSM*/
  associate_public_ip_address = false
  user_data                   = "${file("terraform-demo.sh")}"

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
