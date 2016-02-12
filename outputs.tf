# Outputs
output "id" {
  value = "${aws_instance.chef-server.id}"
}
output "public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}
output "public_dns" {
  value = "${aws_instance.chef-server.public_dns}"
}
output "security_group_id" {
  value = "${aws_security_group.chef-server.id}"
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
  value = "${path.cwd}/.chef/keys/${var.username}.pem"
}
output "organization" {
  value = "${var.org_short}"
}
output "org_validator" {
  value = "${path.cwd}/.chef/keys/${var.org_short}-validator.pem"
}
