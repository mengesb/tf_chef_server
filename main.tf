# Chef Server AWS security group - https://docs.chef.io/server_firewalls_and_ports.html
resource "aws_security_group" "chef-server" {
  name        = "${var.hostname}.${var.domain} security group"
  description = "Chef Server ${var.hostname}.${var.domain}"
  vpc_id      = "${var.aws_vpc_id}"
  tags = {
    Name      = "${var.hostname}.${var.domain} security group"
  }
}
# SSH
resource "aws_security_group_rule" "chef-server_allow_22_tcp_allowed_cidrs" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${split(",", var.allowed_cidrs)}"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# HTTP (nginx)
resource "aws_security_group_rule" "chef-server_allow_80_tcp" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# HTTPS (nginx)
resource "aws_security_group_rule" "chef-server_allow_443_tcp" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# oc_bifrost (nginx LB)
resource "aws_security_group_rule" "chef-server_allow_9683_tcp" {
  type        = "ingress"
  from_port   = 9683
  to_port     = 9683
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# opscode-push-jobs
resource "aws_security_group_rule" "chef-server_allow_10000-10003_tcp" {
  type        = "ingress"
  from_port   = 10000
  to_port     = 10003
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# Egress: ALL
resource "aws_security_group_rule" "chef-server_allow_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-server.id}"
}
# AWS settings
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
#
# Local prep
#
resource "null_resource" "chef-prep" {
  provisioner "local-exec" {
    command = <<-EOF
      rm -rf .chef
      mkdir -p .chef
      openssl rand -base64 512 | tr -d '\r\n' > .chef/encrypted_data_bag_secret
      echo "Local prep complete"
      EOF
  }
}
# Chef provisiong attributes_json and .chef/dna.json templating
resource "template_file" "attributes-json" {
  template = "${file("${path.module}/files/attributes-json.tpl")}"
  vars {
    host   = "${var.hostname}"
    domain = "${var.domain}"
    user   = "${lookup(var.ami_usermap, var.ami_os)}"
  }
}
# knife.rb templating
resource "template_file" "knife-rb" {
  template = "${file("${path.module}/files/knife-rb.tpl")}"
  vars {
    user   = "${var.username}"
    fqdn   = "${var.hostname}.${var.domain}"
    org    = "${var.org_short}"
  }
}
#
# Accept Chef MLSA
#
resource "null_resource" "chef_mlsa" {
  depends_on = ["null_resource.chef-prep"]
  count = "${var.accept_license}"
  provisioner "local-exec" {
    command = <<-EOC
      touch .chef/.license.accepted
      EOC
  }
}
#
# Provision server
#
resource "aws_instance" "chef-server" {
  depends_on    = ["null_resource.chef-prep","null_resource.chef_mlsa"]
  ami           = "${lookup(var.ami_map, "${var.ami_os}-${var.aws_region}")}"
  count         = "${var.server_count}"
  instance_type = "${var.aws_flavor}"
  associate_public_ip_address = "${var.public_ip}"
  subnet_id     = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
  key_name      = "${var.aws_key_name}"
  # AWS tagging
  tags = {
    Name        = "${var.hostname}.${var.domain}"
    Description = "${var.tag_description}"
  }
  # Delete root on termination
  root_block_device = {
    delete_on_termination = "${var.root_delete_termination}"
  }
  connection {
    host        = "${self.public_ip}"
    user        = "${lookup(var.ami_usermap, var.ami_os)}"
    private_key = "${var.aws_private_key_file}"
  }
  # Setup
  provisioner "remote-exec" {
    inline = [
      "mkdir -p .chef",
      "sudo mkdir -p /var/chef/cache /var/chef/cookbooks /var/chef/ssl",
      "sudo service iptables stop",
      "sudo chkconfig iptables off",
      "sudo ufw disable",
      "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v ${var.client_version}",
      "echo 'Version ${var.client_version} of chef-client installed'"
    ]
  }
  # Copy to server script to download necessary cookbooks
  provisioner "file" {
    source = "${path.module}/files/chef-cookbooks.sh"
    destination = ".chef/chef-cookbooks.sh"
  }
  # Run script to download necessary cookbooks
  provisioner "remote-exec" {
    inline = [
      "bash .chef/chef-cookbooks.sh",
    ]
  }
  # Put certificate key
  provisioner "file" {
    source      = "${var.ssl_key}"
    destination = ".chef/${var.hostname}.${var.domain}.key"
  }
  # Put certificate
  provisioner "file" {
    source      = "${var.ssl_cert}"
    destination = ".chef/${var.hostname}.${var.domain}.pem"
  }
  # Put .license.accepted
  provisioner "file" {
    source      = ".chef/.license.accepted"
    destination = ".chef/.license.accepted"
  }
  # Write .chef/dna.json for chef-solo run
  provisioner "remote-exec" {
    inline = [
      "cat > .chef/dna.json <<EOF",
      "${template_file.attributes-json.rendered}",
      "EOF",
    ]
  }
  # Move certs
  provisioner "remote-exec" {
    inline = [
      "sudo mv .chef/${var.hostname}.${var.domain}.* /var/chef/ssl/"
    ]
  }
  # Move in .license.accepted
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /var/opt/chef-manage /var/opt/opscode-push-jobs-server /var/opt/opscode-reporting",
      "sudo cp .chef/.license.accepted /var/opt/chef-manage/.license.accepted",
      "sudo cp .chef/.license.accepted /var/opt/opscode-push-jobs-server/.license.accepted",
      "sudo cp .chef/.license.accepted /var/opt/opscode-reporting/.license.accepted",
      "rm .chef/.license.accepted",
      "echo 'Chef MLSA Accepted: https://www.chef.io/online-master-agreement/'"
    ]
  }
  # Run chef-solo and get us a Chef server
  provisioner "remote-exec" {
    inline = [
      "sudo chef-solo -j .chef/dna.json -o 'recipe[system::default],recipe[chef-server::default],recipe[chef-server::addons]'",
    ]
  }
  # Create first user and org
  provisioner "remote-exec" {
    inline = [
      "sudo chef-server-ctl user-create ${var.username} ${var.user_firstname} ${var.user_lastname} ${var.user_email} ${base64sha256(self.id)} -f .chef/${var.username}.pem",
      "sudo chef-server-ctl org-create ${var.org_short} '${var.org_long}' --association_user ${var.username} --filename .chef/${var.org_short}-validator.pem",
    ]
  }
  # Correct ownership on .chef so we can harvest files
  provisioner "remote-exec" {
    inline = [
      "sudo chown -R ${lookup(var.ami_usermap, var.ami_os)} .chef"
    ]
  }
  # Copy back .chef files
  provisioner "local-exec" {
    command = "scp -r -o stricthostkeychecking=no -i ${var.aws_private_key_file} ${lookup(var.ami_usermap, var.ami_os)}@${aws_instance.chef-server.public_ip}:.chef/* .chef/"
  }
  # Generate knife.rb
  provisioner "local-exec" {
    command = <<-EOC
      [ -f .chef/knife.rb ] && rm -f .chef/knife.rb
      cat > .chef/knife.rb <<EOF
      ${template_file.knife-rb.rendered}
      EOF
      EOC
  }
  # Upload knife.rb
  provisioner "file" {
    source = ".chef/knife.rb"
    destination = ".chef/knife.rb"
  }
  # Push in cookbooks
  provisioner "remote-exec" {
    inline = [
      "sudo knife cookbook upload -a -c .chef/knife.rb --cookbook-path /var/chef/cookbooks",
      "sudo rm -rf /var/chef/cookbooks",
    ]
  }
}
# File sourcing redirection
module "encrypted_data_bag_secret" {
  source = "github.com/mengesb/tf_filemodule"
  file   = ".chef/encrypted_data_bag_secret"
}
module "knife_rb" {
  source = "github.com/mengesb/tf_filemodule"
  file   = ".chef/knife.rb"
}
module "user_pem" {
  source = "github.com/mengesb/tf_filemodule"
  file   = ".chef/${var.username}.pem"
}
module "validator" {
  source = "github.com/mengesb/tf_filemodule"
  file   = ".chef/${var.org_short}-validator.pem"
}
# Register Chef server against itself
resource "null_resource" "chef_chef-server" {
  depends_on = ["aws_instance.chef-server"]
  connection {
    host        = "${aws_instance.chef-server.public_ip}"
    user        = "${lookup(var.ami_usermap, var.ami_os)}"
    private_key = "${var.aws_private_key_file}"
  }
  # Provision with Chef
  provisioner "chef" {
    attributes_json = "${template_file.attributes-json.rendered}"
    environment     = "_default"
    log_to_file     = "${var.log_to_file}"
    node_name       = "${aws_instance.chef-server.tags.Name}"
    run_list        = ["recipe[system::default]","recipe[chef-client::default]","recipe[chef-client::config]","recipe[chef-client::cron]","recipe[chef-client::delete_validation]","recipe[chef-server::default]","recipe[chef-server::addons]"]
    server_url      = "https://${aws_instance.chef-server.tags.Name}/organizations/${var.org_short}"
    skip_install    = true
    validation_client_name = "${var.org_short}-validator"
    validation_key  = "${file("${module.validator.file}")}"
    version         = "${var.client_version}"
  }
}
# Generate pretty output format
resource "template_file" "chef-server-creds" {
  depends_on = ["null_resource.chef_chef-server"]
  template = "${file("${path.module}/files/chef-server-creds.tpl")}"
  vars {
    user   = "${var.username}"
    pass   = "${base64sha256(aws_instance.chef-server.id)}"
    user_p = "${module.user_pem.file}"
    fqdn   = "${aws_instance.chef-server.tags.Name}"
    org    = "${var.org_short}"
    pem    = "${module.validator.file}"
  }
}
# Write generated template file
resource "null_resource" "write-files" {
  provisioner "local-exec" {
    command = <<-EOC
      [ -f .chef/chef-server.creds ] && rm -f .chef/chef-server.creds
      cat > .chef/chef-server.creds <<EOF
      ${template_file.chef-server-creds.rendered}
      EOF
      EOC
  }
}

