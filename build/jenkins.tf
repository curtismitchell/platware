/*resource "aws_instance" "build_jenkins" {
  ami = "${var.ami}"
  instance_type = "m1.small"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.build.id}"]
  tags {
      Name = "jenkins"
  }
  subnet_id = "${var.public_subnet}"
  connection {
    user = "ec2-user"
    key_file = "ssh/cm-key-aws.pem"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo",
    "sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key",
    "sudo yum -y install java-1.7.0-openjdk jenkins",
    "sudo service jenkins start"
    ]
  }
}

output "jenkins" {
  value = "${aws_instance.build_jenkins.public_ip}"
}
*/
