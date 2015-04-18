resource "aws_instance" "cmp" {
  ami = "${var.ami}"
  instance_type = "t2.medium"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.cmp.id}"]
  tags {
      Name = "scalr"
      Desc = "cloud management platform"
  }

  subnet_id = "${var.public_subnet}"
  connection {
    user = "ec2-user"
    key_file = "ssh/cm-key-aws.pem"
  }

  provisioner "remote-exec" {
    inline = [
    "curl https://packagecloud.io/install/repositories/scalr/scalr-server-oss/script.rpm | sudo bash",
    "sudo yum install -y scalr-server"
    ]
  }
}

resource "aws_route53_record" "git" {
   zone_id = "${var.hosted_zone_id}"
   name = "cmp.vesource.com"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.cmp.public_ip}"]
}

resource "aws_security_group" "cmp" {
  name = "cmp"
  description = "Allow web traffic to cmp box"

  vpc_id = "${var.vpc_id}"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  tags {
    name = "cmp"
  }
}
