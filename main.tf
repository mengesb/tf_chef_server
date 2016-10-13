# Chef Server AWS security group - https://docs.chef.io/server_firewalls_and_ports.html
resource "aws_security_group" "chef-server" {
  name        = "${var.instance["hostname"]}.${var.instance["domain"]} security group"
  description = "Chef Server ${var.instance["hostname"]}.${var.instance["domain"]}"
  vpc_id      = "${var.aws_network["vpc"]}"
  tags = {
    Name      = "${var.instance["hostname"]}.${var.instance["domain"]} security group"
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
  access_key = "${var.aws["access_key"]}"
  secret_key = "${var.aws["secret_key"]}"
  region     = "${var.aws_region}"
}
#
# Local prep
#
resource "null_resource" "chef-prep" {
  provisioner "local-exec" {
    command = <<-EOF
      [ -f .chef/encrypted_data_bag_secret ] && rm -f .chef/encrypted_data_bag_secret
      openssl rand -base64 512 | tr -d '\r\n' > .chef/encrypted_data_bag_secret
      echo "Local prep complete"
      EOF
  }
}
# Chef provisiong attributes_json and .chef/dna.json templating
data "template_file" "attributes-json" {
  template = "${file("${path.module}/files/attributes-json.tpl")}"
  vars {
    addons  = "${join(",", formatlist("\\"%s\\"", split(",", var.chef_addons)))}"
    domain  = "${var.instance["domain"]}"
    host    = "${var.instance["hostname"]}"
    license = "${var.chef_license}"
    version = "${var.chef_versions["server"]}"
  }
}
# knife.rb templating
data "template_file" "knife-rb" {
  template = "${file("${path.module}/files/knife-rb.tpl")}"
  vars {
    user   = "${var.chef_user["username"]}"
    fqdn   = "${var.instance["hostname"]}.${var.instance["domain"]}"
    org    = "${var.chef_org["short"]}"
  }
}
#
# Provision server
#
resource "aws_instance" "chef-server" {
  depends_on       = ["null_resource.chef-prep"]
  ami              = "${lookup(var.ami_map, "${var.ami_os}-${var.aws_region}")}"
  count            = 1
  instance_type    = "${var.instance_flavor}"
  associate_public_ip_address = "${var.instance_public}"
  subnet_id        = "${var.aws_network["subnet"]}"
  vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
  key_name         = "${var.instance_key["name"]}"
  tags             = {
    Name           = "${var.instance["hostname"]}.${var.instance["domain"]}"
    Description    = "${var.instance_tag_desc}"
  }
  root_block_device = {
    delete_on_termination = "${var.instance_volume["delete"]}"
    volume_size    = "${var.instance_volume["size"]}"
    volume_type    = "${var.instance_volume["type"]}"
  }
  connection {
    host           = "${self.public_ip}"
    user           = "${lookup(var.ami_usermap, var.ami_os)}"
    private_key    = "${file("${var.instance_key["file"]}")}"
  }
  # Setup
  provisioner "remote-exec" {
    script         = "${path.module}/files/disable_firewall.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p .chef",
      "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v ${var.chef_versions["client"]}",
      "echo 'Version ${var.chef_versions["client"]} of chef-client installed'"
    ]
  }
  # Execute script to download necessary cookbooks
  provisioner "remote-exec" {
    script         = "${path.module}/files/chef-cookbooks.sh"
  }
  # Put certificate key
  provisioner "file" {
    source         = "${var.chef_ssl["key"]}"
    destination    = ".chef/${var.instance["hostname"]}.${var.instance["domain"]}.key"
  }
  # Put certificate
  provisioner "file" {
    source         = "${var.chef_ssl["cert"]}"
    destination    = ".chef/${var.instance["hostname"]}.${var.instance["domain"]}.pem"
  }
  # Write .chef/dna.json for chef-solo run
  provisioner "file" {
    content        = "${data.template_file.attributes-json.rendered}"
    destination    = ".chef/dna.json"
  }
  # Move certs
  provisioner "remote-exec" {
    inline = [
      "sudo mv .chef/${var.instance["hostname"]}.${var.instance["domain"]}.* /var/chef/ssl/"
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
      "sudo chef-server-ctl user-create ${var.chef_user["username"]} ${var.chef_user["first"]} ${var.chef_user["last"]} ${var.chef_user["email"]} ${base64sha256(self.id)} -f .chef/${var.chef_user["username"]}.pem",
      "sudo chef-server-ctl org-create ${var.chef_org["short"]} '${var.chef_org["long"]}' --association_user ${var.chef_user["username"]} --filename .chef/${var.chef_org["short"]}-validator.pem",
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
    command = "scp -r -o stricthostkeychecking=no -i ${var.instance_key["file"]} ${lookup(var.ami_usermap, var.ami_os)}@${self.public_ip}:.chef/* .chef/"
  }
  # Replace local .chef/user.pem file with generated one
  provisioner "local-exec" {
    command = "cp -f .chef/${var.chef_user["username"]}.pem .chef/user.pem"
  }
  # Generate knife.rb
  provisioner "local-exec" {
    command = <<-EOC
      [ -f .chef/knife.rb ] && rm -f .chef/knife.rb
      cat > .chef/knife.rb <<EOF
      ${data.template_file.knife-rb.rendered}
      EOF
      EOC
  }
  # Upload knife.rb
  provisioner "file" {
    content        = "${data.template_file.knife-rb.rendered}"
    destination    = ".chef/knife.rb"
  }
  # Push in cookbooks
  provisioner "remote-exec" {
    inline = [
      "sudo knife cookbook upload -a -c .chef/knife.rb --cookbook-path /var/chef/cookbooks",
      "sudo rm -rf /var/chef/cookbooks",
    ]
  }
}
# Register Chef server against itself
resource "null_resource" "chef_chef-server" {
  depends_on = ["aws_instance.chef-server"]
  connection {
    host        = "${aws_instance.chef-server.public_ip}"
    user        = "${lookup(var.ami_usermap, var.ami_os)}"
    private_key = "${file("${var.instance_key["file"]}")}"
  }
  # Provision with Chef
  provisioner "chef" {
    attributes_json = "${data.template_file.attributes-json.rendered}"
    environment     = "_default"
    log_to_file     = "${var.chef_log}"
    node_name       = "${aws_instance.chef-server.tags.Name}"
    run_list        = ["recipe[system::default]","recipe[chef-client::default]","recipe[chef-client::config]","recipe[chef-client::cron]","recipe[chef-client::delete_validation]","recipe[chef-server::default]","recipe[chef-server::addons]"]
    server_url      = "https://${aws_instance.chef-server.tags.Name}/organizations/${var.chef_org["short"]}"
    skip_install    = true
    user_name       = "${var.chef_user["username"]}"
    user_key        = "${file(".chef/user.pem")}"
  }
}
# Generate pretty output format
data "template_file" "chef-server-creds" {
  template = "${file("${path.module}/files/chef-server-creds.tpl")}"
  vars {
    user   = "${var.chef_user["username"]}"
    pass   = "${base64sha256(aws_instance.chef-server.id)}"
    user_p = ".chef/${var.chef_user["username"]}.pem"
    fqdn   = "${aws_instance.chef-server.tags.Name}"
    org    = "${var.chef_org["short"]}"
  }
}
# Write generated template file
resource "null_resource" "write-files" {
  provisioner "local-exec" {
    command = <<-EOC
      [ -f .chef/chef-server.creds ] && rm -f .chef/chef-server.creds
      cat > .chef/chef-server.creds <<EOF
      ${data.template_file.chef-server-creds.rendered}
      EOF
      EOC
  }
}
