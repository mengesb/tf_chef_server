# Chef Server AWS security group - https://docs.chef.io/server_firewalls_and_ports.html
resource "aws_security_group" "chef-server" {
  name = "chef-server"
  description = "Chef Server"
  vpc_id = "${var.aws_vpc_id}"
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
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}
resource "aws_instance" "chef-server" {
  ami = "${var.aws_ami_id}"
  count = "${var.aws_instance_count}"
  instance_type = "${var.aws_flavor}"
  subnet_id = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
  key_name = "${var.aws_key_name}"
  tags {
    Name = "${format("%s-%02d-%s", var.aws_instance_name, count.index + 1, var.chef_org)}"
  }
  root_block_device = {
    delete_on_termination = true
  }
  connection {
    user = "${var.aws_ami_user}"
    private_key = "${var.aws_private_key_file}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo iptables -A INPUT -p tcp -m multiport --dports 80,443,9683 -j ACCEPT",
      "sudo iptables -A INPUT -p tcp --dport 10000:10003 -j ACCEPT",
      "sudo service iptables save",
      "sudo service iptables restart",
      "[[ -x /usr/sbin/apt-get ]] && sudo apt-get install -y git || sudo yum install -y git",
      "curl -s https://packagecloud.io/install/repositories/chef/stable/script.deb.sh -o script.deb.sh",
      "curl -s https://packagecloud.io/install/repositories/chef/stable/script.rpm.sh -o script.rpm.sh",
      "[[ -x /usr/sbin/apt-get ]] && sudo bash script.deb.sh || sudo bash script.rpm.sh",
      "[[ -x /usr/sbin/apt-get ]] && sudo apt-get install -y chef-server-core || sudo yum install -y chef-server-core",
      "rm -f script.*.sh",
      "sudo chef-server-ctl reconfigure",
      "sudo chef-server-ctl user-create ${var.chef_username} ${var.chef_user_firstname} ${var.chef_user_lastname} ${var.chef_user_email} ${base64encode(aws_instance.chef-server.id)} -f /tmp/${var.chef_username}.pem",
      "sudo chef-server-ctl org-create ${var.chef_org} '${var.chef_org_long}' --association_user ${var.chef_username} --filename /tmp/${var.chef_org}-validator.pem",
      "sudo chef-server-ctl install opscode-reporting",
      "sudo chef-server-ctl reconfigure",
      "sudo opscode-reporting-ctl reconfigure",
      "sudo chef-server-ctl install opscode-manage",
      "sudo chef-server-ctl reconfigure",
      "sudo opscode-manage-ctl reconfigure",
      "sudo chef-server-ctl install opscode-push-jobs-server",
      "sudo chef-server-ctl reconfigure",
      "sudo opscode-push-jobs-server reconfigure",
      "sudo chef-server-ctl reconfigure",
      "sudo chef exec chef-client -z -o chef-server-12"
    ]
  }
  provisioner "local-exec" {
    command = "scp -i ${var.aws_private_key_file} ${var.aws_ami_user}@${aws_instance.chef-server.public_ip}:/tmp/${var.chef_username}.pem /tmp/${var.chef_username}.pem"
  }
  provisioner "local-exec" {
    command = "scp -i ${var.aws_private_key_file} ${var.aws_ami_user}@${aws_instance.chef-server.public_ip}:/tmp/${var.chef_org}-validator.pem /tmp/${var.chef_org}-validator.pem"
  }
}

