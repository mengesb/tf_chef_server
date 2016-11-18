tf_chef_server CHANGELOG
========================

This file is used to list changes made in each version of the tf_chef_server Terraform plan.

v2.0.3 (2016-11-18)
-------------------
- [Brian Menges] - Fix [.kitchen.yml](.kitchen.yml) platform name

v2.0.2 (2016-11-18)
-------------------
- [Julian Dunn] - Fix [terraform.tfvars.example] missing double quote
- [Julian Dunn] - Stringify the booleans (hashicorp/terraform#9751)
- [Brian Menges] - Update chef client and server versions to latest
- [Brian Menges] - Add kitchen-terraform and tests

v2.0.0 (2016-10-13)
-------------------
- [Brian Menges] - Add missing dependent cookbook to [files/chef-cookbooks.sh]
- [Brian Menges] - Convert several string variables to maps
- [Brian Menges] - Remove `tf_filemodule` dependency
- [Brian Menges] - Update Ubuntu 14.04 LTS AMI list in `ami_map`
- [Brian Menges] - Update `remote-exec` provisioner writes of template files to `file` provisioner with `content`
- [Brian Menges] - Update [terraform.tfvars.example] with current variables and defaults
- [Brian Menges] - Set default AMI os to Ubuntu 14.04 LTS
- [Brian Menges] - Removed CentOS 6 from `ami_map`. Root partition resize required to support installation
- [Seth Larson] - Fix `private_key` call in `connection` directive, required `file()` interpolation

v1.3.0 (2016-10-12)
-------------------
- [Brian Menges] - Syntax updates for Terraform v0.7.5
- [Brian Menges] - Chef provider updates

v1.2.1 (2016-05-23)
-------------------
- [Brian Menges] - Added a [CONTRIBUTING](CONTRIBUTING.md) document
- [Brian Menges] - Updated [README.md](README.md) to refer to [CONTRIBUTING](CONTRIBUTING.md) document

v1.2.0 (2016-05-20)
-------------------
- [Brian Menges] - Updated `client_version` to `12.10.24`
- [Brian Menges] - Some small text alignment updates
- [Brian Menges] - Replaced remote-exec for firewall disables with a script [disable_firewall.sh](files/disable_firewall.sh)
- [Brian Menges] - Replaced upload and execute for [chef-cookbooks.sh](files/chef-cookbooks.sh) with remote-execute script
- [Brian Menges] - Tidy up code in [chef-cookbooks.sh](files/chef-cookbooks.sh)
- [Brian Menges] - Ordered variables in `template_file.attributes-json`
- [Brian Menges] - Removed unused variables in `template_file.attributes-json`
- [Brian Menges] - Added `server_addons` variable and input into `template_file.attributes-json` as `addons`
- [Brian Menges] - Added [terraform.tfvars.example](terraform.tfvars.example) to provide an example for `terraform.tfvars`
- [Brian Menges] - Documentation updates

v1.1.4 (2016-05-02)
-------------------
- [Brian Menges] - BUG: Fixed aws_instance tag

v1.1.3 (2016-05-02)
-------------------
- [Brian Menges] - Remove tags on root_block_device

v1.1.2 (2016-05-02)
-------------------
- [Brian Menges] - Remove dependency on `null_resource.chef_mlsa` (deleted resource)

v1.1.1 (2016-05-02)
-------------------
- [Brian Menges] - [README.md](README.md) update

v1.1.0 (2016-05-02)
-------------------
- [Brian Menges] - Replaced `accept_license` numeric with boolean. Now part of `template_file.attributes-json`
- [Brian Menges] - Added `volume_size` and `volume_type` specifications and `root_` variables for mentioned tunables to instance deployted
- [Brian Menges] - Removed `null_resource` for Chef MLSA handles
- [Brian Menges] - Added `server_version` to specify Chef Server installation version
- [Brian Menges] - Set default `root_volume_size` to 20 GB
- [Brian Menges] - Set default `root_volume_type` to `standard`
- [Brian Menges] - Added Name tag to `root_block_device` of `${var.hostname}.${var.domain} /`
- [Brian Menges] - NOTE: incompatible with root type `io1`

v1.0.6 (2016-04-28)
-------------------
- [Brian Menges] - Attempt simplier method to `accept_license`

v1.0.5 (2016-04-28)
-------------------
- [Brian Menges] - Require users of plan to specify `accept_license` and set to `1` to indicate agreement with [Chef MLSA](https://www.chef.io/online-master-agreement/)
- [Brian Menges] - Implement `null_resource.chef_mlsa` between prep and chef-solo run
- [Brian Menges] - Update a few `depends_on` blocks
- [Brian Menges] - Fix an scp copy back for files

v1.0.4 (2016-04-26)
-------------------
- [Brian Menges] - Fix [chef-server-creds](files/chef-server-creds.tpl) template. Specify User PEM and Org Validator files correctly
- [Brian Menges] - Move module `validator` down in file sourcing redirection block

v1.0.3 (2016-04-26)
-------------------
- [Brian Menges] - Minor update to [chef-server-creds.tpl](files/chef-server-creds.tpl)

v1.0.2 (2016-04-20)
-------------------
- [Brian Menges] - Chef ingredient warning: push-server deprecated, use push-jobs-server

v1.0.1 (2016-04-20)
-------------------
- [Brian Menges] - Add recipe['chef-client::cron'] to run_list

v1.0.0 (2016-04-20)
-------------------
- [Brian Menges] - Update HEREDOC syntax use
- [Brian Menges] - Code review
- [Brian Menges] - Release v1.0.0

v0.2.14 (2016-04-15)
-------------------
- [Brian Menges] - Add `chef_handler` cookbook

v0.2.13 (2016-04-15)
-------------------
- [Brian Menges] - Add `chef-client` cookbook and dependencies to `chef-cookbooks.sh`
- [Brian Menges] - Fix syntax error in `attributes-json.tpl`

v0.2.12 (2016-04-15)
-------------------
- [Brian Menges] - Update `attributes-json.tpl`, set `system` cookbook to restart network immediately on set
- [Brian Menges] - Alphabetize `attributes-json.tpl`, except for `fqdn`
- [Brian Menges] - Add attributes and run_list to setup chef-client as cron job with splay

v0.2.11 (2016-04-14)
-------------------
- [Brian Menges] - Add `skip_install = true` to chef-client run (already installed, don't need to do it again)

v0.2.10 (2016-04-14)
-------------------
- [Brian Menges] - Add `knife_rb` output

v0.2.9 (2016-04-13)
-------------------
- [Brian Menges] - Add `${path.module}` to cookbook script file transfer resource

v0.2.8 (2016-04-13)
-------------------
- [Brian Menges] - Add `public_ip` input variable to indicate public IP association to AWS instance

v0.2.7 (2016-04-13)
-------------------
- [Brian Menges] - Reformat [CHANGELOG.md](CHANGELOG.md)
- [Brian Menges] - Remove Route53 hooks
- [Brian Menges] - Add `client_version` variable for chef-client version control
- [Brian Menges] - Add `log_to_file` variable for chef-client runtime logging
- [Brian Menges] - Update `depends_on` instances
- [Brian Menges] - Use [tf_filemodule](https://github.com/mengesb/tf_filemodule) instead of custom local module
- [Brian Menges] - Documentation updates

v0.2.6 (2016-03-28)
-------------------
- [Brian Menges] - Syntax update per Terraform [0.6.14](https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md#0614-march-21-2016)

v0.2.5 (2016-03-22)
-------------------
- [Brian Menges] - Added handle for internal DNS on Route53
- [Brian Menges] - Added recipe[system::default] to run_list

v0.2.4 (2016-03-21)
-------------------
- [Brian Menges] - Add runtime sample GIST

v0.2.3 (2016-03-21)
-------------------
- [Brian Menges] - Formatting and consistency updates
- [Brian Menges] - No new functionality

v0.2.2 (2016-03-21)
-------------------
- [Brian Menges] - Added org validator to output
- [Brian Menges] - Handle IPTables and UFW

v0.2.1 (2016-03-18)
-------------------
- [Brian Menges] - Replaced `aws_ami_id` with `ami_map`
- [Brian Menges] - Replaced `ami_user_id` with `ami_usermap`
- [Brian Menges] - Using lookups in `variables.tf` for AMI (`ami_map` lookup based on `ami_os` and `aws_region`)
- [Brian Menges] - Using lookups in `variables.tf` for default AMI user id (`ami_usermap` lookup based on `ami_os`)
- [Brian Menges] - Re-added virtual boolean control over Route53 using `r53` variable (0/1)
- [Brian Menges] - Added Route53 TTL variable `r53_ttl`

v0.2.0 (2016-03-15)
-------------------
- [Brian Menges] - Overhauled plan logistics
- [Brian Menges] - Using chef-server cookbook instead of lots of chef-server-ctl commands
- [Brian Menges] - workaround implemented to use a generated file within plan (validator-pem module)
- [Brian Menges] - Dependency on Route53 currently, investigate making this an option again
- [Brian Menges] - Dependency on valid SSL certificate
- [Brian Menges] - Documentation updates as necessary
- [Brian Menges] - Pre-selected AMI maps (based on stated chef server compatibility)
- [Brian Menges] - Need to re-implement firewall handling better

v0.1.6 (2016-02-16)
-------------------
- [Brian Menges] - Packagecloud.io had some "senior moments". Brute force fix some of its shenanigans.

v0.1.5 (2016-02-15)
-------------------
- [Brian Menges] - Fix outputs - no var.password

v0.1.4 (2016-02-15)
-------------------
- [Brian Menges] - Documentation cleanup and consisteny with other tf_chef works
- [Brian Menges] - Removed chef_server_url output
- [Brian Menges] - Removed public_ip output
- [Brian Menges] - Removed org_validator output
- [Brian Menges] - Renamed username_pem to user_pem
- [Brian Menges] - Adjusted outputs order to reflect display
- [Brian Menges] - Created chef_server_creds output text

v0.1.3 (2016-02-14)
-------------------
- [Brian Menges] - Removed keys/ subdirectory from .chef

v0.1.2 (2016-02-14)
-------------------
- [Brian Menges] - Changed chef_server_basename to basename
- [Brian Menges] - Changed chef_server_count to count
- [Brian Menges] - Added variable `ssh_cidrs` to allow SSH access restrictions. Default: `0.0.0.0/0`
- [Brian Menges] - Added ports 10000-10003 to security groups (push-jobs)
- [Brian Menges] - Supporting documentation updates

v0.1.1 (2016-02-11)
-------------------
- [Brian Menges] - Bump version
- [Brian Menges] - Move some operations around
- [Brian Menges] - Place PEM key files under `.chef/keys` now
- [Brian Menges] - Remove hacks to support Delivery (not necessary anymore)
- [Brian Menges] - Update variables, trim some characters
- [Brian Menges] - Update `README.md`
- [Brian Menges] - Update `CHANGELOG.md` prettier

v0.1.0 (2016-02-04)
-------------------
- [Brian Menges] - Bump version
- [Brian Menges] - Make CHANGELOG.md prettier

v0.0.2 (2016-02-04)
-------------------
- [Brian Menges] - Removed cookbooks directory from repo

v0.0.1 (2016-02-04)
-------------------
- [Brian Menges] - Implement version in `CHANGELOG.md`
- [Brian Menges] - Create `CHANGELOG.md`
- [Brian Menges] - Finalize module
- [Brian Menges] - Updates to `outputs.tf`, added more information
- [Brian Menges] - Updates to `variables.tf`, adding descriptions

33mb9e2aa0 (2016-02-04)
-------------------
- [Brian Menges] - Fixed old chef exec command hanging around
- [Brian Menges] - Fixed IPTables issues; flush then set complete rule set

33m14b29b9 (2016-02-04)
-------------------
- [Brian Menges] - Fixing references to aws_instance provider items

33m5bc32bc (2016-02-04)
-------------------
- [Brian Menges] - removed cookbooks directory file sync
- [Brian Menges] - execute chef server creation directly at server
- [Brian Menges] - create first user
- [Brian Menges] - create first org
- [Brian Menges] - associate user to org
- [Brian Menges] - download user pem
- [Brian Menges] - download org validator pem

33m954a88d (2016-02-04)
-------------------
- [Brian Menges] - fix bulleted list

33ma4c360c (2016-02-04)
-------------------
- [Brian Menges] - Supported OSes
- [Brian Menges] - more assumptions

33m2879244 (2016-02-04)
-------------------
- [Brian Menges] - Delete email linking

33me856561 (2016-02-04)
-------------------
- [Brian Menges] - Correcting e-mail link for Brian Menges

33m8b5553f (2016-02-04)
-------------------
- [Brian Menges] - Correcting linking syntax for users

33m1077c11 (2016-02-04)
-------------------
- [Brian Menges] - Correcting linking syntax

33me261f30 (2016-02-04)
-------------------
- [Brian Menges] - Updating README.md
- [Brian Menges] - More explanation about how to use this module

33mb66e077 (2016-02-03)
-------------------
- [Brian Menges] - moved connection outside of the provisioners per @afiune recommendation
- [Brian Menges] - Added TODO to get rid of the provisioner file hack
- [Brian Menges] - creative addition of git package supporting CentOS and Ubuntu

33m3015e80 (2016-02-03)
-------------------
- [Brian Menges] - SPELLING!

33m4a9a5eb (2016-02-03)
-------------------
- [Brian Menges] - Fixing org to chef_org

33m2440c7c (2016-02-03)
-------------------
- [Brian Menges] - Mixed up region and vpc

33m5475d18 (2016-02-03)
-------------------
- [Brian Menges] - Removing AMI magic
- [Brian Menges] - Getting too complex, simplifying things

33m3a1a2b0 (2016-02-02)
-------------------
- [Brian Menges] - Fixed ami reference, using lookup now

33m3f76ee1 (2016-02-02)
-------------------
- [Brian Menges] - Initial commit

33mc5e5f07 (2016-02-02)
-------------------
- [Brian Menges] - Create repo

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
