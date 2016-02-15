# tf_chef_server
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

### AWS variables

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

### tf_chef_server variables

* `basename`: CHEF server's basename. Default: `chef-server`
* `count`: CHEF Server count. Default: `1`; DO NOT CHANGE!
* `org_short`: CHEF organization to create. Default: `terraform`
* `org_long`: CHEF organization long name. Default: `Terraform CHEF Organization`
* `username`: First CHEF Server user. Default: `admin`
* `user_firstname`: CHEF Server user's first name. Default: `Admin`
* `user_lastname`: CHEF Server user's last name. Default: `User`
* `user_email`: CHEF Server user's e-mail address. Default: `admin@domain.tld`
* `ssh_cidrs`: The comma seperated list of addresses in CIDR format to allow SSH access. Default: `0.0.0.0/0`

## Outputs

* `chef_server_creds`: Formatted text output with details about the CHEF Server
* `organization`: The short form name of the organization created on the CHEF Server
* `public_dns`: The public DNS of the instance created
* `security_group_id`: The AWS security group id for this instance
* `username`: The first user's CHEF Server username
* `user_password`: The password for your first chef user
* `user_pem`: The pem key for the first user on your CHEF Server

## Contributors

* [Brian Menges](https://github.com/mengesb)
* [Salim Afiune](https://github.com/afiune)

## Contributing

Please understand that this is a work in progress and is subject to change rapidly. Please be sure to keep up to date with the repo should you fork, and feel free to contact me regarding development and suggested direction

## `CHANGELOG`

Please refer to the [`CHANGELOG.md`](CHANGELOG.md)

## License

This is licensed undert [the Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0).
