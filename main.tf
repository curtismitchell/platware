module "vpc" {
  source = "./vpc"
  vpc_cidr = "10.1.0.0/16"
  public_subnet = "10.1.0.0/18"
  private_subnet = "10.1.64.0/19"
  data_subnet = "10.1.96.0/19"
  env_prefix = "dev"
  aws_access_key = "AKIAJ3G4LYAPVWHNK3JA"
  aws_secret = "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"
  aws_region = "us-east-1"
}

output "public_sub" {
    value = "${module.vpc.public_vpc_id}"
}

output "private_sub" {
    value = "${module.vpc.private_vpc_id}"
}

output "data_sub" {
  value = "${module.vpc.data_vpc_id}"
}
