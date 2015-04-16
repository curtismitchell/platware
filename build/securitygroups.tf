resource "aws_security_group" "build" {
  name = "build"
    description = "Allow web traffic to build box"

  vpc_id = "${var.vpc_id}"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  ingress {
      from_port = 8111
      to_port = 8111
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  tags {
    name = "build"
  }
}

resource "aws_security_group" "sshable" {
  name = "sshable"
    description = "Allow ssh"

  vpc_id = "${var.vpc_id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  tags {
    name = "sshable"
  }
}
