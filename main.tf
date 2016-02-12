# CHEF Server AWS security group - https://docs.chef.io/server_firewalls_and_ports.html
resource "aws_security_group" "chef-server" {
  name = "chef-server"
  description = "CHEF Server"
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
# Local prep for CHEF Server creation
resource "null_resource" "chef-prep" {
  provisioner "local-exec" {
    command = <<EOF
rm -rf ${path.cwd}/.chef
mkdir -p ${path.cwd}/.chef/keys
mkdir -p ${path.cwd}/.chef/trusted_certs
mkdir -p ${path.cwd}/.chef/local-mode-cache/cache/cookbooks
echo "Local prep complete"
EOF
  }
}
# Provision CHEF Server
resource "aws_instance" "chef-server" {
  ami = "${var.aws_ami_id}"
  count = "${var.chef_server_count}"
  instance_type = "${var.aws_flavor}"
  subnet_id = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
  key_name = "${var.aws_key_name}"
  tags = {
    Name = "${format("%s-%02d-%s", var.chef_server_basename, count.index + 1, var.org_short)}"
  }
  root_block_device = {
    delete_on_termination = true
  }
  connection {
    host = "${self.public_ip}"
    user = "${var.aws_ami_user}"
    private_key = "${var.aws_private_key_file}"
  }
  # Basic setup
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/.chef/keys",
      "mkdir -p /tmp/.chef/trusted_certs",
      "chmod 777 -R /tmp/.chef",
      "EC2IPV4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)",
      "EC2FQDN=$(curl http://169.254.169.254/latest/meta-data/public-hostname)",
      "EC2HOST=$(echo $EC2FQDN | sed 's/..*//')",
      "EC2DOMA=$(echo $EC2FQDN | sed \"s/$EC2HOST.//\")",
      "sudo sed -i '/localhost/{n;s/^/${self.public_ip} ${self.public_dns}\\n/}' /etc/hosts",
      "[ -f /etc/sysconfig/network ] && sudo hostname ${self.public_dns} || sudo hostname $EC2HOST",
      "echo ${self.public_dns}|sed 's/\\..*//' > /tmp/hostname",
      "sudo chown root:root /tmp/hostname",
      "[ -f /etc/sysconfig/network ] && sudo sed -i 's/^HOSTNAME.*/HOSTNAME=${self.public_dns}/' /etc/sysconfig/network || sudo cp /tmp/hostname /etc/hostname",
      "sudo rm /tmp/hostname",
      "sudo iptables -F",
      "sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT",
      "sudo iptables -A INPUT -p icmp -j ACCEPT",
      "sudo iptables -A INPUT -i lo -j ACCEPT",
      "sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT",
      "sudo iptables -A INPUT -p tcp -m multiport --dports 80,443,9683 -j ACCEPT",
      "sudo iptables -A INPUT -p tcp --dport 10000:10003 -j ACCEPT",
      "sudo iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited",
      "sudo iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited",
      "sudo service iptables save",
      "sudo service iptables restart"
    ]
  }
  # Setup packages
  provisioner "remote-exec" {
    inline = [
      "[ -x /usr/sbin/apt-get ] && sudo apt-get install -y git || sudo yum install -y git",
      "curl -s https://packagecloud.io/install/repositories/chef/stable/script.deb.sh -o /tmp/.chef/script.deb.sh",
      "curl -s https://packagecloud.io/install/repositories/chef/stable/script.rpm.sh -o /tmp/.chef/script.rpm.sh",
      "[ -x /usr/sbin/apt-get ] && sudo bash /tmp/.chef/script.deb.sh || sudo bash /tmp/.chef/script.rpm.sh",
      "[ -x /usr/sbin/apt-get ] && sudo apt-get install -y chef-server-core || sudo yum install -y chef-server-core",
      "rm -f /tmp/.chef/script.*.sh",
      "sudo chef-server-ctl reconfigure",
      "sudo chef-server-ctl user-create ${var.username} ${var.user_firstname} ${var.user_lastname} ${var.user_email} ${base64encode(self.id)} -f /tmp/.chef/keys/${var.username}.pem",
      "sudo chef-server-ctl org-create ${var.org_short} '${var.org_long}' --association_user ${var.username} --filename /tmp/.chef/keys/${var.org_short}-validator.pem",
      "sudo chef-server-ctl install opscode-reporting",
      "sudo chef-server-ctl reconfigure",
      "sudo opscode-reporting-ctl reconfigure",
      "sudo chef-server-ctl install chef-manage",
      "sudo chef-server-ctl reconfigure",
      "sudo chef-manage-ctl reconfigure",
      "sudo chef-server-ctl install opscode-push-jobs-server",
      "sudo chef-server-ctl reconfigure",
      "sudo opscode-push-jobs-server-ctl reconfigure",
      "sudo chef-server-ctl reconfigure",
      "sudo cp -r /var/opt/opscode/nginx/ca /tmp/.chef/trusted_certs",
      "sudo chown -R ${var.aws_ami_user} /tmp/.chef",
      "sudo mv /tmp/.chef/trusted_certs/ca/*.crt /tmp/.chef/trusted_certs",
      "sudo rm -rf /tmp/.chef/trusted_certs/ca"
    ]
  }
  # Copy back necessary files
  provisioner "local-exec" {
    command = "scp -r -o stricthostkeychecking=no -i ${var.aws_private_key_file} ${var.aws_ami_user}@${self.public_ip}:/tmp/.chef/* ${path.cwd}/.chef/"
  }
  # Write knife.rb
  provisioner "local-exec" {
    command = <<EOF
cat > ${path.cwd}/.chef/knife.rb <<EOK
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                '${var.username}'
client_key               "#{current_dir}/keys/${var.username}.pem"
validation_client_name   '${var.org_short}-validator'
validation_key           "#{current_dir}/keys/${var.org_short}-validator.pem"
chef_server_url          'https://${aws_instance.chef-server.public_dns}/organizations/${var.org_short}'
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/local-mode-cache/cache/cookbooks"]
EOK
echo "knife.rb written to ${path.cwd}/.chef/knife.rb"
EOF
  }
  # Upload starting cookbooks
  provisioner "local-exec" {
    command = <<EOF
mkdir -p ${path.cwd}/.chef/cookbooks
git clone https://github.com/chef-cookbooks/delivery-cluster.git ${path.cwd}/.chef/cookbooks
rm -rf ${path.cwd}/.chef/cookbooks/.chef
cd ${path.cwd}/.chef/cookbooks
berks install
berks upload --no-ssl-verify
cd ..
rm -rf cookbooks
EOF
  }
}
