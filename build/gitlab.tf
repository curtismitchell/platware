resource "aws_instance" "build_jenkins" {
  ami = "${var.ami}"
  instance_type = "m1.small"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.build.id}"]
  tags {
      Name = "gitlab"
  }
  subnet_id = "${var.public_subnet}"
  connection {
    user = "ec2-user"
    key_file = "ssh/cm-key-aws.pem"
  }

  provisioner "file" {
      source = "build/gitlab.rb"
      destination = "~/gitlab.rb"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo wget -O ~/gitlab.rpm https://downloads-packages.s3.amazonaws.com/centos-7.0.1406/gitlab-7.9.2_omnibus-1.el7.x86_64.rpm",
    "sudo yum -y install ~/gitlab.rpm",
    "sudo cp ~/gitlab.rb /etc/gitlab/gitlab.rb",
    "sudo gitlab-ctl reconfigure"
    ]
  }
}

output "gitlab" {
  value = "${aws_instance.build_gitlab.public_ip}"
}
