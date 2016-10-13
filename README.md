# tf_chef_server
Terraform module to setup a Chef Server in standalone mode. Nothing spectacular here and a very simple implementation. Once this is up and running, recommend you use Chef to configure your Chef Server to suit your needs.


## Assumptions

* Requires:
  * AWS (duh!)
  * AWS subnet id
  * AWS VPC id
  * SSL certificate/key for created instance
  * Terraform >= 0.7.4
* Uses a public IP and public DNS
* Creates default security group as follows:
  * 22/tcp: SSH
  * 443/tcp: HTTPS
  * 80/tcp: HTTP
  * 10000-10003: Chef Push Jobs
* Understand Terraform and ability to read the source


## Usage


### Module

In your terraform plan:
```
module "module_name_here" {
  source = "github.com/mengesb/tf_chef_server"
  aws = {
    access_key = "AWS_ACCESS_KEY_ID"
    secret_key = "AWS_SECRET_ACCESS_KEY"
  }
  aws_network = {
    subnet = "AWS_SUBNET_ID"
    vpc    = "AWS_VPC_ID"
  }
  chef_license = "true"
  chef_ssl = {
    cert = "SSL_CERTIFICATE"
    key  = "SSL_CERTIFICATE_KEY"
  }
  instance_key = {
    file = "AWS_INSTANCE_SSH_KEY_FILE"
    name = "AWS_INSTANCE_KEY_NAME"
  }
}
```


### Directly

1. Clone this repo: `git clone https://github.com/mengesb/tf_chef_server.git`
2. Make a local terraform.tfvars file: `cp terraform.tfvars.example terraform.tfvars`
3. Edit `terraform.tfvars` with your editor of choice, ensuring `accept_license` is set to `true`
4. Test the plan: `terraform plan`
5. Apply the plan: `terraform apply`


## Supported OSes
All supported OSes are 64-bit and HVM (though PV should be supported)

* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS (Default)
* Ubuntu 16.04 LTS (pending)
* CentOS 7 (pending)
* Others (here be dragons! Please see Map Variables)


## AWS

These resources will incur charges on your AWS bill. It is your responsibility to delete the resources.


## Input variables


### AWS variables

* `aws`: AWS accessibility settings
  * `access_key`: Your AWS key, usually referred to as `AWS_ACCESS_KEY_ID`
  * `secret_key`: Your secret for your AWS key, usually referred to as `AWS_SECRET_ACCESS_KEY`
* `aws_region`: AWS region you want to deploy to. Default: `us-west-1`
* `aws_network`: AWS networking settings
  * `subnet`: The AWS id of the subnet to use. Example: `subnet-ffffffff`
  * `vpc`: The AWS id of the VPC to use. Example: `vpc-ffffffff`


### AWS instance settings

* `instance`: AWS EC2 instance host settings
  * `domain`: Domain name of the host. Default: `localdomain`
  * `hostname`: Hostname of the host. Default: `localhost`
* `instance_flavor`: The AWS instance type. Default: `c3.xlarge`
* `instance_key`: AWS EC2 instance key settings
  * `file`: The full path to the private key matching the uploaded public key
  * `name`: The public key pair name on AWS to use
* `instance_public`: Associate public IP to then instance. Default `true` (REQUIRED)
* `instance_tag_desc`: Text field tag 'Description'
* `instance_volume`: AWS EC2 instance root volume settings
  * `delete`: Delete root device on VM termination. Default: `true`
  * `size`: Size of the root volume in GB. Default: `20`
  * `type`: Type of root volume. Supports `gp2` and `standard`. Default: `gp2`


### tf_chef_server variables

* `allowed_cidrs`: The comma seperated list of addresses in CIDR format to allow SSH access. Default: `0.0.0.0/0`
* `chef_addons`: Comma seperated list of addons to install. Default: `manage,push-jobs-server,reporting`
* `chef_license`: [Chef MLSA license](https://www.chef.io/online-master-agreement/) agreement. Default: `false`; change to `true` to indicate agreement
* `chef_log`: Log chef provisioner to file. Default: `true`
* `chef_org`: Chef organization settings
  * `short`: Chef organization to create. Default: `chef`
  * `long`: Chef organization long name. Default: `Chef Organization`
* `chef_ssl`: Chef server SSL settings
  * `cert`: SSL certificate in PEM format
  * `key`: SSL certificate key
* `chef_user`: Chef user settings
  * `email`: Chef Server user's e-mail address. Default: `admin@domain.tld`
  * `first`: Chef Server user's first name. Default: `Admin`
  * `last`: Chef Server user's last name. Default: `User`
  * `username`: First Chef Server user. Default: `admin`
* `chef_versions`: Chef software versions
  * `client`: Chef client version. Default: `12.15.19`
  * `server`: Chef server version. Default: `12.9.1`


### AMI map variables

The below mapping variables construct selection criteria

* `ami_map`: AMI selection map comprised of `ami_os` and `aws_region`
* `ami_usermap`: Default username selection map based off `ami_os`

The `ami_map` is a combination of `ami_os` and `aws_region` which declares the AMI selected. To override this pre-declared AMI, define

```
ami_map.<ami_os>-<aws_region> = "value"
```

Variable `ami_os` should be one of the following:

* centos7
* ubuntu12
* ubuntu14 (default)
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

* `chef_server_url`: The created chef server's URL
* `credentials`: Formatted text output with details about the Chef Server (sensitive)
* `fqdn`: The fully qualified domain name of the server
* `knife_rb`: Chef knife.rb file for user generated
* `organization`: The short form name of the organization created on the Chef Server
* `password`: Password for the created chef user (sensitive)
* `public_ip`: The public IP address of the instance
* `private_ip`: The private IP address of the instance
* `secret_file`: The encrypted data bag secret file
* `security_group_id`: The AWS security group id for this instance
* `user_key`: The created user's private key for chef access
* `username`: The created user's username


## Contributors

* [Brian Menges](https://github.com/mengesb)
* [Salim Afiune](https://github.com/afiune)
* [Seth Larson](https://github.com/sclarson)

## Runtime sample

You can view a runtime output sample here: [tf_chef_server-runtime.txt](https://gist.github.com/mengesb/dbc393ee9aeaf2c0a9a7)


## Contributing

Please understand that this is a work in progress and is subject to change rapidly. Be sure to keep up to date with the repo should you fork, and feel free to contact me regarding development and suggested direction. Familiarize yoursef with the [contributing](CONTRIBUTING.md) before making/submitting changes.


## `CHANGELOG`

Please refer to the [`CHANGELOG.md`](CHANGELOG.md)


## License

This is licensed under [the Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0).


