# AWS provider specific configs
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {}
variable "aws_private_key_file" {}
variable "aws_vpc_id" {}
variable "aws_subnet_id" {}
variable "aws_ami_user" {}
varaible "aws_ami_id" {
  default = "ami-45844401"
}
variable "aws_flavor" {
  default = "c3.xlarge"
}
variable "aws_region" {
  default = "us-west-1"
}
variable "aws_instance_name" {
  default = "chef-server"
}
variable "aws_instance_count" {
  default = 1
}
# tf_chef_server specific configs
variable "chef_org" {
  default = "example"
}
