# Chef Server AWS security group - https://docs.chef.io/server_firewalls_and_ports.html
resource "aws_security_group" "chef-server" {
  name = "chef-server"
  description = "Chef Server"
  vpc_id = "${var.chef_server_aws_vpc_id}"
  tags = {
    Name = "chef-server security group"
  }
}
# SSH - all
resource "aws_security_group_rule" "chef-server_allow_22_tcp_all" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# HTTP (nginx)
resource "aws_security_group_rule" "chef-server_allow_80_tcp_all" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# HTTPS (nginx)
resource "aws_security_group_rule" "chef-server_allow_443_tcp_all" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# oc_bifrost (nginx LB)
resource "aws_security_group_rule" "chef-server_allow_9683_tcp_all" {
  type = "ingress"
  from_port = 9683
  to_port = 9683
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# Egress: ALL
resource "aws_security_group_rule" "chef-server_allow_all" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
provider "aws" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region = "${var.aws_default_region}"
}
module "chef-server-ami" {
  source = "./chef-server-ami"
  region = "${var.aws_default_region}"
  dist = "${var.dist}"
  arch = "${var.arch}"
}
resource "aws_instance" "chef-server" {
  #ami = "${module.chef-server-ami.ami_id}"
  ami = "ami-45844401"
  count = "${var.aws_instance_count}"
  instance_type = "${var.aws_flavor}"
  subnet_id = "${var.chef_server_aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
  key_name = "${var.aws_key_name}"
  tags {
    Name = "${format("%s-%02d-%s", var.aws_tag_name, count.index + 1, var.org)}"
  }
  root_block_device = {
    delete_on_termination = true
  }
  provisioner "file" {
    connection {
      user = "${module.chef-server-ami.username}"
      private_key = "${file("${var.private_key_file}")}"
    }
    source = "cookbooks"
    destination = "/tmp"
  }
  provisioner "remote-exec" {
    connection {
      user = "${module.chef-server-ami.username}"
      private_key = "${file("${var.private_key_file}")}"
    }
    inline = [
      "sudo iptables -A INPUT -p tcp -m multiport --dports 80,443,9683 -j ACCEPT",
      "sudo iptables -A INPUT -p tcp --dport 10000:10003 -j ACCEPT",
      "sudo service iptables save",
      "sudo service iptables restart",
      "sudo ${module.chef-server-ami.packager} install -y tcpdump git curl wget",
      "curl -sLO https://www.chef.io/chef/install.sh > /dev/null",
      "sudo bash ./install.sh -P chefdk -n",
      "sudo rm install.sh",
      "cd /tmp",
      "sudo chef exec chef-client -z -o chef-server-12"
    ]
  }
}

