resource "aws_security_group" "chef" {
  name = "chef"
    description = "Allow web traffic to chef"

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

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  ingress {
      from_port = 4321
      to_port = 4321
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  ingress {
      from_port = 9680
      to_port = 9685
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
  }

  tags {
    name = "chef"
  }
}

resource "aws_instance" "chef" {
  ami = "ami-96a818fe"
  instance_type = "t2.medium"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.chef.id}"]
  tags {
      Name = "chef"
  }
  subnet_id = "${var.public_subnet}"
  connection {
    user = "centos"
    key_file = "ssh/cm-key-aws.pem"
  }

  provisioner "file" {
    source = "cmp/chef-server.rb"
    destination = "~/chef-server.rb"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo yum -y update",
    "sudo yum install -y wget",
    "wget https://web-dl.packagecloud.io/chef/stable/packages/el/6/chef-server-core-12.0.7-1.el6.x86_64.rpm",
    "wget https://web-dl.packagecloud.io/chef/stable/packages/el/6/opscode-manage-1.11.4-1.el5.x86_64.rpm",
    "wget https://web-dl.packagecloud.io/chef/stable/packages/el/6/opscode-push-jobs-server-1.1.6-1.x86_64.rpm",
    "sudo rpm -Uvh chef-server-core-12.0.7-1.el6.x86_64.rpm",
    "sudo cp ~/chef-server.rb /etc/opscode/chef-server.rb",
    "sudo chef-server-ctl reconfigure",
    "sudo chef-server-ctl user-create curtismitchell Curtis Mitchell curtismitchell@gmail.com 5iveL!fe --filename /tmp/userkey.pem",
    "sudo chef-server-ctl org-create vesource Vesource --association_user curtismitchell --filename /tmp/chef-validator.pem",
    "sudo rpm -Uvh opscode-manage-1.11.4-1.el5.x86_64.rpm",
    "sudo opscode-manage-ctl reconfigure",
    "sudo chef-server-ctl reconfigure",
    "sudo rpm -Uvh opscode-push-jobs-server-1.1.6-1.x86_64.rpm",
    "sudo opscode-push-jobs-server-ctl reconfigure",
    "sudo chef-server-ctl reconfigure"
    ]
  }
}

resource "aws_route53_record" "chef" {
   zone_id = "${var.hosted_zone_id}"
   name = "chef.vesource.com"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.chef.public_ip}"]
}

output "chef" {
  value = "${aws_instance.chef.public_ip}"
}
