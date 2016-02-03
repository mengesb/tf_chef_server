# Outputs
output "id" {
  value = "${aws_instance.chef-server.id}"
}
output "public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}
output "security_group_id" {
  value = "${aws_security_group.chef-server.id}"
}
output "chef_server_url" {
  value = "https://${aws_instance.chef-server.public_ip}/organizations/${var.chef_org}"
}
