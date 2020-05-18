variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_instance_lber" {
  type = object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_groups             = list(string)
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    tags                        = map(string)
  })
}

variable "aws_instance_gw" {
  type = object({
    count                       = number
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_groups             = list(string)
    key_name                    = string
    iam_instance_profile        = string
    associate_public_ip_address = bool
    tags                        = map(string)
  })
}