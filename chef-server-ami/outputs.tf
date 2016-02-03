output "ami_id" {
  value = "${lookup(var.amis, format(\"%s-%s-%s\", var.region, var.dist, var.arch))}"
}
output "username" {
  value = "${lookup(var.ami_user, var.dist)}"
}
output "packager" {
  value = "${lookup(var.packager, var.dist)}"
}
