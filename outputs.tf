# Outputs
output "id" {
  value = "${aws_instance.chef-server.id}"
}
output "security_group_id" {
  value = "${aws_security_group.chef-server.id}"
}
output "public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}
output "public_dns" {
  value = "${aws_instance.chef-server.public_dns}"
}
output "organization" {
  value = "${var.org_short}"
}
output "chef_server_url" {
  value = "https://${aws_instance.chef-server.public_dns}/organizations/${var.org_short}"
}
output "username" {
  value = "${var.username}"
}
output "password" {
  value = "${base64encode(aws_instance.chef-server.id)}"
}
output "username_pem" {
  value = "${path.cwd}/.chef/${var.username}.pem"
}
output "org_validator" {
  value = "${path.cwd}/.chef/${var.org_short}-validator.pem"
}
output "secret_key_file" {
  value = "${path.cwd}/.chef/encrypted_data_bag_secret"
}
