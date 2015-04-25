/*
Creates VPC + Subnets
*/

/* create VPC */
resource "aws_vpc" "dev" {
    cidr_block = "${var.vpc_cidr}"

    tags {
        Name = "${var.env_prefix}-vpc"
    }
}

/* Add an Internet Gateway to the VPC */
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.dev.id}"
}

/* Add a public subnet for the NAT instance and ELBs for public apps */
resource "aws_subnet" "pub" {
    vpc_id = "${aws_vpc.dev.id}"
    cidr_block = "${var.public_subnet}"
    availability_zone = "${var.aws_region}d"
    tags {
        Name = "${var.env_prefix}-pubsubc"
    }
}

/* Add a second public subnet in a different AZ */
resource "aws_subnet" "pub2" {
    vpc_id = "${aws_vpc.dev.id}"
    cidr_block = "${var.public_subnet_2}"
    availability_zone = "${var.aws_region}b"
    tags {
        Name = "${var.env_prefix}-pubsubb"
    }
}

/* Public subnet route table */
resource "aws_route_table" "full_rt" {
  vpc_id = "${aws_vpc.dev.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
      Name = "${var.env_prefix}-pubsub-route-table"
  }
}

resource "aws_route_table_association" "p" {
    subnet_id = "${aws_subnet.pub.id}"
    route_table_id = "${aws_route_table.full_rt.id}"
}

resource "aws_route_table_association" "p2" {
    subnet_id = "${aws_subnet.pub2.id}"
    route_table_id = "${aws_route_table.full_rt.id}"
}

/* Internal subnets */
resource "aws_subnet" "int" {
    vpc_id = "${aws_vpc.dev.id}"
    cidr_block = "${var.private_subnet}"
    availability_zone = "${var.aws_region}b"
    tags {
        Name = "${var.env_prefix}-privsubb"
    }
}

resource "aws_subnet" "int2" {
    vpc_id = "${aws_vpc.dev.id}"
    cidr_block = "${var.private_subnet_2}"
    availability_zone = "${var.aws_region}d"
    tags {
        Name = "${var.env_prefix}-privsubc"
    }
}

/* private subnet route table */
resource "aws_route_table" "int" {
  vpc_id = "${aws_vpc.dev.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.vpn.id}"
  }

  tags {
      Name = "${var.env_prefix}-intsub-route-table"
  }
}

resource "aws_route_table_association" "int" {
    subnet_id = "${aws_subnet.int.id}"
    route_table_id = "${aws_route_table.int.id}"
}

resource "aws_route_table_association" "int2" {
    subnet_id = "${aws_subnet.int2.id}"
    route_table_id = "${aws_route_table.int.id}"
}

/* data subnets */
resource "aws_subnet" "data" {
  vpc_id = "${aws_vpc.dev.id}"
  cidr_block = "${var.data_subnet}"
  availability_zone = "${var.aws_region}b"
  tags {
    Name = "${var.env_prefix}-datasubb"
  }
}

resource "aws_subnet" "data2" {
  vpc_id = "${aws_vpc.dev.id}"
  cidr_block = "${var.data_subnet_2}"
  availability_zone = "${var.aws_region}d"
  tags {
    Name = "${var.env_prefix}-datasubc"
  }
}

/* data subnet route table */
resource "aws_route_table" "data" {
  vpc_id = "${aws_vpc.dev.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.vpn.id}"
  }

  tags {
      Name = "${var.env_prefix}-datasub-route-table"
  }
}

resource "aws_route_table_association" "data" {
    subnet_id = "${aws_subnet.data.id}"
    route_table_id = "${aws_route_table.data.id}"
}

resource "aws_route_table_association" "data2" {
    subnet_id = "${aws_subnet.data2.id}"
    route_table_id = "${aws_route_table.data.id}"
}

output "public_subnet_1" {
  value = "${aws_subnet.pub.id}"
}

output "public_subnet_2" {
  value = "${aws_subnet.pub2.id}"
}

output "private_subnet_1" {
  value = "${aws_subnet.int.id}"
}

output "private_subnet_2" {
  value = "${aws_subnet.int2.id}"
}

output "data_subnet_1" {
  value = "${aws_subnet.data.id}"
}

output "data_subnet_2" {
  value = "${aws_subnet.data2.id}"
}

output "vpc_id" {
  value = "${aws_vpc.dev.id}"
}
