variable "env_prefix" {
  default = "dev"
}

variable "public_subnet" { }
variable "private_subnet" { }
variable "data_subnet" { }
variable "public_subnet_2" { }
variable "private_subnet_2" { }
variable "data_subnet_2" { }
variable "vpc_cidr" { }
variable "aws_access_key" { }
variable "aws_secret" { }
variable "aws_region" { }
variable "key_name" { }
variable "key_path" {
    description = "Path to your private key."
}
