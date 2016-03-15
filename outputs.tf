# Outputs
output "credentials" {
  value = "${template_file.chef-server-creds.rendered}"
}
output "fqdn" {
  value = "${aws_instance.chef-server.tags.Name}"
}
output "private_ip" {
  value = "${aws_instance.chef-server.private_ip}"
}
output "public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}
output "organization" {
  value = "${var.org_short}"
}
output "security_group_id" {
  value = "${aws_security_group.chef-server.id}"
}
output "secret_file" {
  value = ".chef/encrypted_data_bag_secret"
}
