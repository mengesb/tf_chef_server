#
# AWS provider specific configs
#
variable "aws" {
  type             = "map"
  description      = "AWS accessibility settings"
  default          = {
    access_key     = ""
    secret_key     = ""
  }
}
variable "aws_network" {
  type             = "map"
  description      = "AWS networking settings"
  default          = {
    subnet         = ""
    vpc            = ""
  }
}
variable "aws_region" {
  type             = "string"
  description      = "AWS Region to deploy to"
  default          = "us-west-1"
}
#
# AMI mapping
#
variable "ami_map" {
  type             = "map"
  description      = "AMI map of OS/region (2016-03-14)"
  default          = {
    centos7-us-east-1       = "ami-6d1c2007"
    centos7-us-west-2       = "ami-d2c924b2"
    centos7-us-west-1       = "ami-af4333cf"
    centos7-eu-central-1    = "ami-9bf712f4"
    centos7-eu-west-1       = "ami-7abd0209"
    centos7-ap-southeast-1  = "ami-f068a193"
    centos7-ap-southeast-2  = "ami-fedafc9d"
    centos7-ap-northeast-1  = "ami-eec1c380"
    centos7-ap-northeast-2  = "ami-c74789a9"
    centos7-sa-east-1       = "ami-26b93b4a"

    ubuntu16-us-east-1      = "-1"
    ubuntu16-us-west-2      = "-1"
    ubuntu16-us-west-1      = "-1"
    ubuntu16-eu-central-1   = "-1"
    ubuntu16-eu-west-1      = "-1"
    ubuntu16-ap-southeast-1 = "-1"
    ubuntu16-ap-southeast-2 = "-1"
    ubuntu16-ap-northeast-1 = "-1"
    ubuntu16-ap-northeast-2 = "-1"
    ubuntu16-sa-east-1      = "-1"

    ubuntu14-us-east-1      = "ami-4f0c4758"
    ubuntu14-us-west-2      = "ami-f319c293"
    ubuntu14-us-west-1      = "ami-38004858"
    ubuntu14-eu-central-1   = "ami-7cef1113"
    ubuntu14-eu-west-1      = "ami-74692b07"
    ubuntu14-ap-southeast-1 = "ami-af4fe8cc"
    ubuntu14-ap-southeast-2 = "ami-233b0940"
    ubuntu14-ap-northeast-1 = "ami-a0865cc1"
    ubuntu14-ap-northeast-2 = "-1"
    ubuntu14-sa-east-1      = "ami-72cb561e"

    ubuntu12-us-east-1      = "ami-88dfdee2"
    ubuntu12-us-west-2      = "ami-1a977e7a"
    ubuntu12-us-west-1      = "ami-4f285a2f"
    ubuntu12-eu-central-1   = "ami-3cf61153"
    ubuntu12-eu-west-1      = "ami-65932916"
    ubuntu12-ap-southeast-1 = "ami-26e32845"
    ubuntu12-ap-southeast-2 = "ami-d54e6eb6"
    ubuntu12-ap-northeast-1 = "ami-f2afa79c"
    ubuntu12-ap-northeast-2 = "-1"
    ubuntu12-sa-east-1      = "ami-2661ec4a"
  }
}
variable "ami_os" {
  type             = "string"
  description      = "Chef server OS (options: centos7, [centos6], ubuntu16, ubuntu14)"
  default          = "ubuntu14"
}
variable "ami_usermap" {
  type             = "map"
  description      = "Default username map for AMI selected"
  default          = {
    centos7        = "centos"
    centos6        = "centos"
    ubuntu16       = "ubuntu"
    ubuntu14       = "ubuntu"
    ubuntu12       = "ubuntu"
  }
}
#
# specific configs
#
variable "allowed_cidrs" {
  type             = "string"
  description      = "List of CIDRs to allow SSH from (CSV list allowed)"
  default          = "0.0.0.0/0"
}
variable "chef_addons" {
  type             = "string"
  description      = "Comma seperated list of addons to install. Default: `manage,push-jobs-server,reporting`"
  default          = "manage,push-jobs-server,reporting"
}
variable "chef_license" {
  type             = "string"
  description      = "Acceptance of the Chef MLSA: https://www.chef.io/online-master-agreement/"
  default          = "false"
}
variable "chef_log" {
  #type             = "boolean"
  description      = "Log chef provisioner to file"
  default          = "true"
}
variable "chef_org" {
  type             = "map"
  description      = "Chef organization settings"
  default          = {
    long           = "Chef Organization"
    short          = "chef"
  }
}
variable "chef_ssl" {
  type             = "map"
  description      = "Chef server SSL settings"
  default          = {
    cert           = ""
    key            = ""
  }
}
variable "chef_user" {
  type             = "map"
  description      = "Chef user settings"
  default          = {
    email          = "chef.admin@domain.tld"
    first          = "Chef"
    last           = "Admin"
    username       = "chefadmin"
  }
}
variable "chef_versions" {
  type             = "map"
  description      = "Chef software versions"
  default          = {
    client         = "12.16.42"
    server         = "12.11.1"
  }
}
variable "instance" {
  type             = "map"
  description      = "EC2 instance host settings"
  default          = {
    domain         = "localdomain"
    hostname       = "localhost"
  }
}
variable "instance_flavor" {
  type             = "string"
  description      = "EC2 instance flavor (type). Default: c3.xlarge"
  default          = "c3.xlarge"
}
variable "instance_key" {
  type             = "map"
  description      = "EC2 instance SSH key settings"
  default          = {
    file           = ""
    name           = ""
  }
}
variable "instance_public" {
  #type             = "boolean"
  description      = "Associate a public IP to the instance"
  default          = "true"
}
variable "instance_tag_desc" {
  type             = "string"
  description      = "EC2 instance description tag"
  default          = "Created using Terraform (tf_chef_server)"
}
variable "instance_volume" {
  type             = "map"
  description      = "EC2 instance root volume settings"
  default          = {
    delete         = "true"
    size           = 20
    type           = "gp2"
  }
}
