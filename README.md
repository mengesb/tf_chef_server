# tf_aws_chef_server
Terraform module to setup a CHEF server

## Assumptions

* Uses AWS
* You will be creating your own VPC and Subnet
* Default security group implementation

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
* `aws_ami_id`: The AWS id of the AMI. Default: `ami-45844401` [CentOS 6 (x86_64) - with Updates HVM (us-west-1)|https://aws.amazon.com/marketplace/pp/B00NQAYLWO]
* `aws_flavor`: The AWS instance type. Default: `c3.xlarge`
* `aws_instance_name`: The AWS tag for Name. Default: `chef-server` will result in a Name tag of `${var.aws_instance_name}-${var.aws_instance_count}-${var.chef_org}`
* `aws_instance_count`: The number of AWS instances to deploy. Deafult: `1`, DO NOT CHANGE!
* `chef_org`: The organization to create on the CHEF server. Default: `example`

## Outputs

* `id`: The AWS instance id of the instance created
* `public_ip`: The public IP of the instance created
* `security_group_id`: The AWS security group id for this instance
* `chef_server_url`: The URL of the CHEF server created

## Contributors

* @mengesb
* @afiune

## Contributing

Please understand that this is a work in progress and is subject to change rapidly. Please be sure to keep up to date with the repo should you fork, and feel free to contact me regarding development and suggested direction

## `CHANGELOG`

Please refer to the [`CHANGELOG.md`|CHANGELOG.md]

## License

This is licensed undert [the Apache 2.0 license|https://www.apache.org/licenses/LICENSE-2.0].
