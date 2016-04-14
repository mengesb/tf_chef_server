# Outputs
output "credentials" {
  value = "${template_file.chef-server-creds.rendered}"
}
output "fqdn" {
  value = "${aws_instance.chef-server.tags.Name}"
}
output "knife_rb" {
  value = "${module.knife_rb.file}"
}
output "organization" {
  value = "${var.org_short}"
}
output "organization_validator" {
  value = "${module.validator.file}"
}
output "private_ip" {
  value = "${aws_instance.chef-server.private_ip}"
}
output "public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}
output "secret_file" {
  value = "${module.encrypted_data_bag_secret.file}"
}
output "security_group_id" {
  value = "${aws_security_group.chef-server.id}"
}

