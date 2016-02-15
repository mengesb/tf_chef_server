# Outputs
output "chef_server_creds" {
  value = "\nCreated organization: ${var.org_short}\nusername: ${var.username}\npassword: ${var.password}\nWeb login: https://${aws_instance.chef-server.public_dns}/organizations/${var.org_short}"
}
output "organization" {
  value = "${var.org_short}"
}
output "public_dns" {
  value = "${aws_instance.chef-server.public_dns}"
}
output "security_group_id" {
  value = "${aws_security_group.chef-server.id}"
}
output "secret_key_file" {
  value = "${path.cwd}/.chef/encrypted_data_bag_secret"
}
output "username" {
  value = "${var.username}"
}
output "user_password" {
  value = "${base64encode(aws_instance.chef-server.id)}"
}
output "user_pem" {
  value = "${path.cwd}/.chef/${var.username}.pem"
}
