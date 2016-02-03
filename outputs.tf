# Outputs
output "aws_instance_id" {
  value = "${aws_instance.chef-server.id}"
}
output "aws_instance_public_ip" {
  value = "${aws_instance.chef-server.public_ip}"
}
output "aws_security_group_id" {
  value = "${aws_security_group.chef-server.id}"
}
output "url" {
  value = "https://${aws_instance.chef-server.public_ip}/organizations/${var.org}"
}
