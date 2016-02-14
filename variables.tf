# AWS provider specific configs
variable "aws_access_key" {
  description = "Your AWS key (ex. $AWS_ACCESS_KEY_ID)"
}
variable "aws_secret_key" {
  description = "Your AWS secret (ex. $AWS_SECRET_ACCESS_KEY)"
}
variable "aws_key_name" {
  description = "Name of the key pair uploaded to AWS"
}
variable "aws_private_key_file" {
  description = "Full path to your local private key"
}
variable "aws_vpc_id" {
  description = "AWS VPC id (ex. vpc-ffffffff)"
}
variable "aws_subnet_id" {
  description = "AWS Subnet id (ex. subnet-ffffffff)"
}
variable "aws_ami_user" {
  description = "AWS AMI default username"
}
variable "aws_ami_id" {
  description = "AWS Instance ID (region dependent)"
  default = "ami-45844401"
}
variable "aws_flavor" {
  description = "AWS Instance type to deploy"
  default = "c3.xlarge"
}
variable "aws_region" {
  description = "AWS Region to deploy to"
  default = "us-west-1"
}
# tf_chef_server specific configs
variable "count" {
  description = "Number of CHEF Servers to provision. DO NOT CHANGE!"
  default = 1
}
variable "basename" {
  description = "Basename for AWS Name tag of CHEF Server"
  default = "chef-server"
}
variable "org_short" {
  description = "Short CHEF Server organization name (lowercase alphanumeric characters only)"
  default = "example"
}
variable "org_long" {
  description = "Long form name of your first CHEF Server organization"
  default = "Example CHEF Organization"
}
variable "username" {
  description = "Username of the first CHEF Server user"
  default = "example"
}
variable "user_firstname" {
  description = "CHEF Server user's first name"
  default = "Example"
}
variable "user_lastname" {
  description = "CHEF Server user's last name"
  default = "User"
}
variable "user_email" {
  description = "CHEF Server user's e-mail"
  default = "example@domain.tld"
}
variable "ssh_cidrs" {
  description = "List of CIDRs to allow SSH from"
  default = "0.0.0.0/0"
}
