resource "aws_instance" "build_gitlab" {
  ami = "ami-08714d60"
  instance_type = "c4.large"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.build.id}", "${aws_security_group.sshable.id}"]
  tags {
      Name = "gitlab"
  }
  subnet_id = "${var.public_subnet}"
  connection {
    user = "ubuntu"
    key_file = "ssh/cm-key-aws.pem"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo sed -i 's/ip-172-30-0-77.us-west-2.compute.internal/git.vesource.com/g' /etc/gitlab/gitlab.rb",
    "sudo gitlab-ctl reconfigure"
    ]
  }
}

resource "aws_route53_record" "git" {
   zone_id = "${var.hosted_zone_id}"
   name = "git.vesource.com"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.build_gitlab.public_ip}"]
}

output "gitlab" {
  value = "${aws_instance.build_gitlab.public_ip}"
}
