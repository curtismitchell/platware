/*resource "aws_instance" "nat" {
    ami = "ami-224dc94a"
    instance_type = "m1.small"
    security_groups = ["${aws_security_group.vpc_nat_group.id}"]
    connection {
      user = "ec2-user"
      key_file = "${var.key_path}"
    }
    key_name = "${var.key_name}"
    associate_public_ip_address = true
    source_dest_check = false
    subnet_id = "${aws_subnet.pub.id}"

    tags {
        Name = "${var.env_prefix}_nat"
    }
}*/

resource "aws_instance" "vpn" {
  ami = "ami-ce1453a6"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.vpc_nat_group.id}"]
  connection {
    user = "openvpnas"
    key_file = "${var.key_path}"
  }
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  source_dest_check = false
  subnet_id = "${aws_subnet.pub.id}"
  user_data = "public_hostname=vpn.vesource.com"

  tags {
      Name = "${var.env_prefix}_vpn"
  }
}

resource "aws_security_group" "vpc_nat_group" {
  name = "vpc_nat_group"
    description = "Allow all inbound traffic from app subnets"

  vpc_id = "${aws_vpc.dev.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.office_cidr}"]
      self = false
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["${aws_subnet.pub.cidr_block}", "${aws_subnet.pub2.cidr_block}"]
      self = false
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["${aws_subnet.pub.cidr_block}", "${aws_subnet.pub2.cidr_block}"]
      self = false
  }

  ingress {
      from_port = 943
      to_port = 943
      protocol = "tcp"
      cidr_blocks = ["${var.office_cidr}"]
      self = false
  }

  ingress {
      from_port = 1194
      to_port = 1194
      protocol = "udp"
      cidr_blocks = ["${var.office_cidr}"]
      self = false
  }

  /* NAT */
  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = [
          "${aws_subnet.pub.cidr_block}",
          "${aws_subnet.pub2.cidr_block}",
          "${aws_subnet.int.cidr_block}",
          "${aws_subnet.int2.cidr_block}"
      ]
      self = false
  }

  tags {
    name = "${var.env_prefix}_vpc_nat_group"
  }
}

resource "aws_route53_record" "vpn" {
   zone_id = "${var.hosted_zone_id}"
   name = "vpn.vesource.com"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.vpn.public_ip}"]
}

resource "aws_security_group" "allow_bastion" {
    name = "allow_bastion_ssh"
    description = "Allow access from bastion host"
    vpc_id = "${aws_vpc.dev.id}"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.vpc_nat_group.id}"]
        self = false
    }
}

output "bastion" {
  value = "${aws_instance.vpn.public_ip}"
}
