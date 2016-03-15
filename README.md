# tf_chef_server
Terraform module to setup a Chef Server in standalone mode. Nothing spectacular here and a very simple implementation. Once this is up and running, recommend you use Chef to configure your Chef Server to suit your needs.

## Assumptions

* Uses AWS
* You will supply the subnet
* You will supply the VPC
* Uses a public IP and public DNS
* Creates default security group as follows:
  * 22/tcp: SSH
  * 443/tcp: HTTPS
  * 80/tcp: HTTP
  * 10000-10003: Chef Push Jobs
* Understand Terraform and ability to read the source

## Supported OSes
All supported OSes are 64-bit and HVM (though PV should be supported)

* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS
* Ubuntu 16.04 LTS (pending)
* CentOS 6 (Default)
* CentOS 7 (pending)
* Others (here be dragons! Please see Map Variables)

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
* `aws_flavor`: The AWS instance type. Default: `c3.xlarge`

### tf_chef_server variables

* `tag_description`: Text field tag 'Description'
* `hostname`: Chef server's basename. Default: `chef-server`
* `domain`: Chef server's basename. Default: `chef-server`
* `server_count`: Chef Server count. Default: `1`; DO NOT CHANGE!
* `org_short`: Chef organization to create. Default: `terraform`
* `org_long`: Chef organization long name. Default: `Terraform Chef Organization`
* `username`: First Chef Server user. Default: `admin`
* `user_firstname`: Chef Server user's first name. Default: `Admin`
* `user_lastname`: Chef Server user's last name. Default: `User`
* `user_email`: Chef Server user's e-mail address. Default: `admin@domain.tld`
* `allowed_cidrs`: The comma seperated list of addresses in CIDR format to allow SSH access. Default: `0.0.0.0/0`
* `ssl_cert`: Chef Server SSL certificate in PEM format
* `ssl_key`: Chef Server SSL certificate key
* `r53_zone_id`: AWS Route53 Zone ID to add an A record for the Chef Server

### Map variables

The below mapping variables construct selection criteria

* `ami_map`: AMI selection map comprised of `ami_os` and `aws_region`
* `ami_usermap`: Default username selection map based off `ami_os`

The `ami_map` is a combination of `ami_os` and `aws_region` which declares the AMI selected. To override this pre-declared AMI, define

```
ami_map.<ami_os>-<aws_region> = "value"
```

Variable `ami_os` should be one of the following:

* centos6
* centos7
* ubuntu12
* ubuntu14
* ubuntu16

Variable `aws_region` should be one of the following:

* us-east-1
* us-west-2
* us-west-1 (default)
* eu-central-1
* eu-west-1
* ap-southeast-1
* ap-southeast-2
* ap-northeast-1
* ap-northeast-2
* sa-east-1
* Custom (must be an AWS region, requires setting `ami_map` and setting AMI value)

Map `ami_usermap` uses `ami_os` to look the default username for interracting with the instance. To override this pre-declared user, define

```
ami_usermap.<ami_os> = "value"
```

## Outputs

* `credentials`: Formatted text output with details about the Chef Server
* `fqdn`: The fully qualified domain name of the Chef Server
* `organization`: The short form name of the organization created on the Chef Server
* `public_ip`: The public IP address of the instance
* `private_ip`: The private IP address of the instance
* `security_group_id`: The AWS security group id for this instance
* `secret_file`: The encrypted data bag secret file

## Contributors

* [Brian Menges](https://github.com/mengesb)
* [Salim Afiune](https://github.com/afiune)

## Contributing

Please understand that this is a work in progress and is subject to change rapidly. Please be sure to keep up to date with the repo should you fork, and feel free to contact me regarding development and suggested direction

## `CHANGELOG`

Please refer to the [`CHANGELOG.md`](CHANGELOG.md)

## License

This is licensed under [the Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0).

