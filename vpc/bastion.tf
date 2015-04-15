resource "aws_instance" "nat" {
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
}

resource "aws_security_group" "vpc_nat_group" {
  name = "vpc_nat_group"
    description = "Allow all inbound traffic from app subnets"

  vpc_id = "${aws_vpc.dev.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
  value = "${aws_instance.nat.public_ip}"
}
