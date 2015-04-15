resource "aws_instance" "build" {
  ami = "${var.ami}"
  instance_type = "m1.small"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.build.id}"]
  tags {
      Name = "teamcity"
  }
  subnet_id = "${var.public_subnet}"
  connection {
    user = "ec2-user"
    key_file = "ssh/cm-key-aws.pem"
  }

  provisioner "file" {
      source = "build/tc-control-script.sh"
      destination = "~/tc-control-script.sh"
  }

  provisioner "remote-exec" {
    script = "build/teamcity.sh"
  }
}

output "teamcity" {
  value = "${aws_instance.build.public_ip}"
}
