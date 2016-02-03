variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_default_region" {
  default = "us-west-1"
}
variable "aws_tag_name" {
  default = "chef-server"
}
variable "aws_instance_count" {
  default = 1
}
variable "aws_key_name" {}
variable "private_key_file" {
  default = "/tmp/id_rsa"
}
variable "dist" {
  default = 6
}
variable "arch" {
  default = "x86_64"
}
variable "name" {
  default = "chef-server"
}
variable "org" {
  default = "test"
}
variable "aws_flavor" {
  default = "c3.xlarge"
}
variable "aws_vpc_cidr" {
  default = "10.10.10.0/24"
}
variable "aws_subnet_cidr" {
  default = "10.10.10.0/24"
}
variable "chef_server_aws_vpc_id" {}
variable "chef_server_aws_subnet_id" {}

