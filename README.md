# tf_aws_chef_server
Terraform module to setup a CHEF Server in standalone mode. Nothing spectacular here and a very simple implementation. Once this is up and running, recommend you use CHEF to configure your CHEF Server to suit your needs.

## Assumptions

* Uses AWS
* You will supply the AMI
* You will supply the subnet
* You will supply the VPC
* Uses a public IP and public DNS
* Creates default security group as follows:
  * 22/tcp: SSH
  * 443/tcp: HTTPS
  * 80/tcp: HTTP
  * 10000-10003: CHEF Push Jobs
* Understand Terraform and ability to read the source

## Supported OSes
All supported OSes are 64-bit and HVM (though PV should be supported)

* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS
* CentOS 6 (Default)
* CentOS 7

## AWS

These resources will incur charges on your AWS bill. It is your responsibility to delete the resources.

## Input variables

* `aws_access_key`: Your AWS key, usually referred to as `AWS_ACCESS_KEY_ID`
* `aws_secret_key`: Your secret for your AWS key, usually referred to as `AWS_SECRET_ACCESS_KEY`
* `aws_region`: AWS region you want to deploy to. Default: `us-west-1`
* `aws_key_name`: The private key pair name on AWS to use (String)
* `aws_private_key_file`: The full path to the private kye matching `aws_key_name` public key on AWS
* `aws_vpc_id`: The AWS id of the VPC to use. Example: `vpc-ffffffff`
* `aws_subnet_id`: The AWS id of the subnet to use. Example: `subnet-ffffffff`
* `aws_ami_user`: The user for the AMI you're using. Example: `centos`
* `aws_ami_id`: The AWS id of the AMI. Default: `ami-45844401` [CentOS 6 (x86_64) - with Updates HVM (us-west-1)](https://aws.amazon.com/marketplace/pp/B00NQAYLWO)
* `aws_flavor`: The AWS instance type. Default: `c3.xlarge`
* `aws_instance_name`: The AWS tag for Name. Default: `chef-server` will result in a Name tag of `${var.aws_instance_name}-${var.aws_instance_count}-${var.chef_org}`
* `aws_instance_count`: The number of AWS instances to deploy. Deafult: `1`, DO NOT CHANGE!
* `org_short`: The organization to create on the CHEF Server. Default: `example`
* `org_long`: The long organization name to create on the CHEF Server. Default: `Example CHEF Organization`
* `username`: The first user for your chef server. Default: `example`
* `user_firstname`: The first user's first name. Default: `Example`
* `user_lastname`: The first user's last name. Default: `User`
* `user_email`: The first user's e-mail address. Default: `example@domain.tld`

## Outputs

* `id`: The AWS instance id of the instance created
* `public_ip`: The public IP of the instance created
* `public_dns`: The public DNS of the instance created
* `security_group_id`: The AWS security group id for this instance
* `chef_server_url`: The URL of the CHEF Server created
* `username`: The first user's CHEF Server username
* `password`: The password for your first chef user
* `username_pem`: The pem key for the first user on your CHEF Server
* `organization`: The short form name of the organization created on the CHEF Server
* `org_validator`: The file for the CHEF Server's validation PEM

## Contributors

* [Brian Menges](https://github.com/mengesb)
* [Salim Afiune](https://github.com/afiune)

## Contributing

Please understand that this is a work in progress and is subject to change rapidly. Please be sure to keep up to date with the repo should you fork, and feel free to contact me regarding development and suggested direction

## `CHANGELOG`

Please refer to the [`CHANGELOG.md`](CHANGELOG.md)

## License

This is licensed undert [the Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0).
