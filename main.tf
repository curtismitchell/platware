module "vpc" {
  source = "./vpc"
  vpc_cidr = "10.1.0.0/16"
  public_subnet = "10.1.0.0/20"
  public_subnet_2 = "10.1.16.0/20"
  data_subnet = "10.1.32.0/20"
  data_subnet_2 = "10.1.48.0/20"
  private_subnet = "10.1.64.0/19"
  private_subnet_2 = "10.1.96.0/19"
  env_prefix = "dev"
  key_name = "${var.aws.key_name}"
  key_path = "${var.aws.private_key_path}"
  aws_access_key = "${var.aws.access_key}"
  aws_secret = "${var.aws.secret}"
  aws_region = "${var.aws.region}"
  hosted_zone_id = "${var.aws.hosted_zone_id}"
  office_cidr = "${var.aws.office_cidr}"
}

output "public_sub" {
    value = "${module.vpc.public_subnet_1}"
}

output "private_sub" {
    value = "${module.vpc.private_subnet_1}"
}

output "data_sub" {
  value = "${module.vpc.data_subnet_1}"
}

output "public_sub2" {
    value = "${module.vpc.public_subnet_2}"
}

output "private_sub2" {
    value = "${module.vpc.private_subnet_2}"
}

output "data_sub2" {
  value = "${module.vpc.data_subnet_2}"
}
