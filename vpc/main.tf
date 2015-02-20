variable "env_prefix" {
  default = "dev"
}

variable "public_subnet" {}
variable "private_subnet" {}
variable "data_subnet" {}
variable "vpc_cidr" {}
variable "aws_access_key" {}
variable "aws_secret" {}
variable "aws_region" {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "dev" {
    cidr_block = "${var.vpc_cidr}"

    tags {
        Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.dev.id}"
}

resource "aws_subnet" "pub" {
    vpc_id = "${aws_vpc.dev.id}"
    cidr_block = "${var.public_subnet}"
    tags {
        Name = "${var.env_prefix}-public-subnet"
    }
}

resource "aws_subnet" "int" {
    vpc_id = "${aws_vpc.dev.id}"
    cidr_block = "${var.private_subnet}"
    tags {
        Name = "${var.env_prefix}-private-subnet"
    }
}

resource "aws_subnet" "data" {
  vpc_id = "${aws_vpc.dev.id}"
  cidr_block = "${var.data_subnet}"
  tags {
    Name = "${var.env_prefix}-data-subnet"
  }
}

resource "aws_route_table_association" "a" {
    subnet_id = "${aws_subnet.pub.id}"
    route_table_id = "${aws_vpc.dev.main_route_table_id}"
}

resource "aws_network_acl" "main" {
    vpc_id = "${aws_vpc.dev.id}"
    subnet_id = "${aws_subnet.int.id}"

    ingress = {
        protocol = "tcp"
        rule_no = 20
        action = "allow"
        cidr_block =  "${var.public_subnet}"
        from_port = 80
        to_port = 80
    }

    egress = {
        protocol = "tcp"
        rule_no = 10
        action = "allow"
        cidr_block =  "${var.private_subnet}"
        from_port = 49152
        to_port = 65535
    }
}

output "public_vpc_id" {
  value = "${aws_subnet.pub.id}"
}

output "private_vpc_id" {
  value = "${aws_subnet.int.id}"
}

output "data_vpc_id" {
  value = "${aws_subnet.data.id}"
}
