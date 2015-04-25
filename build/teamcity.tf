/*resource "aws_instance" "build" {
  ami = "${var.ami}"
  instance_type = "t2.medium"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.sshable.id}", "${aws_security_group.build.id}"]
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

  provisioner "file" {
      source = "build/nginx.conf"
      destination = "~/nginx.conf"
  }

  provisioner "remote-exec" {
    script = "build/teamcity.sh"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo /etc/init.d/teamcity start",
    "sudo yum install -y nginx",
    "sudo cp ~/nginx.conf /etc/nginx/nginx.conf",
    "sudo service nginx start"
    ]
  }
}

resource "aws_route53_record" "teamcity" {
   zone_id = "${var.hosted_zone_id}"
   name = "build.vesource.com"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.build.public_ip}"]
}

output "teamcity" {
  value = "${aws_instance.build.public_ip}"
}*/
