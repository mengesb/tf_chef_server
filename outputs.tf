# Outputs
output "chef_server_url" {
  value            = "https://${aws_instance.chef-server.tags.Name}/organizations/${var.chef_org["short"]}"
}
output "credentials" {
  sensitive        = true
  value            = "${data.template_file.chef-server-creds.rendered}"
}
output "fqdn" {
  value            = "${aws_instance.chef-server.tags.Name}"
}
output "knife_rb" {
  value            = ".chef/knife.rb"
}
output "organization" {
  value            = "${var.chef_org["short"]}"
}
output "password" {
  sensitive        = true
  value            = "${base64sha256(aws_instance.chef-server.id)}"
}
output "private_ip" {
  value            = "${aws_instance.chef-server.private_ip}"
}
output "public_ip" {
  value            = "${aws_instance.chef-server.public_ip}"
}
output "secret_file" {
  value            = ".chef/encrypted_data_bag_secret"
}
output "security_group_id" {
  value            = "${aws_security_group.chef-server.id}"
}
output "user_key" {
  value            = ".chef/${var.chef_user["username"]}.pem"
}
output "username" {
  value            = "${var.chef_user["username"]}"
}
