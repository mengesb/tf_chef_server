v0.2.6 (2016-03-28)
-------------------
- Syntax update per Terraform [0.6.14](https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md#0614-march-21-2016)

v0.2.5 (2016-03-22)
-------------------
- Added handle for internal DNS on Route53
- Added recipe[system::default] to run_list

v0.2.4 (2016-03-21)
-------------------
- Add runtime sample GIST

v0.2.3 (2016-03-21)
-------------------
- Formatting and consistency updates
- No new functionality

v0.2.2 (2016-03-21)
-------------------
- Added org validator to output
- Handle IPTables and UFW

v0.2.1 (2016-03-18)
-------------------
- Replaced `aws_ami_id` with `ami_map`
- Replaced `ami_user_id` with `ami_usermap`
- Using lookups in `variables.tf` for AMI (`ami_map` lookup based on `ami_os` and `aws_region`)
- Using lookups in `variables.tf` for default AMI user id (`ami_usermap` lookup based on `ami_os`)
- Re-added virtual boolean control over Route53 using `r53` variable (0/1)
- Added Route53 TTL variable `r53_ttl`

v0.2.0 (2016-03-15)
-------------------
- Overhauled plan logistics
- Using chef-server cookbook instead of lots of chef-server-ctl commands
- workaround implemented to use a generated file within plan (validator-pem module)
- Dependency on Route53 currently, investigate making this an option again
- Dependency on valid SSL certificate
- Documentation updates as necessary
- Pre-selected AMI maps (based on stated chef server compatibility)
- Need to re-implement firewall handling better

v0.1.6 (2016-02-16)
-------------------
- Packagecloud.io had some "senior moments". Brute force fix some of its shenanigans.

v0.1.5 (2016-02-15)
-------------------
- Fix outputs - no var.password

v0.1.4 (2016-02-15)
-------------------
- Documentation cleanup and consisteny with other tf_chef works
- Removed chef_server_url output
- Removed public_ip output
- Removed org_validator output
- Renamed username_pem to user_pem
- Adjusted outputs order to reflect display
- Created chef_server_creds output text

v0.1.3 (2016-02-14)
-------------------
- Removed keys/ subdirectory from .chef

v0.1.2 (2016-02-14)
-------------------
- Changed chef_server_basename to basename
- Changed chef_server_count to count
- Added variable `ssh_cidrs` to allow SSH access restrictions. Default: `0.0.0.0/0`
- Added ports 10000-10003 to security groups (push-jobs)
- Supporting documentation updates

v0.1.1 (2016-02-11)
-------------------
- Bump version
- Move some operations around
- Place PEM key files under `.chef/keys` now
- Remove hacks to support Delivery (not necessary anymore)
- Update variables, trim some characters
- Update `README.md`
- Update `CHANGELOG.md` prettier

v0.1.0 (2016-02-04)
-------------------
- Bump version
- Make CHANGELOG.md prettier

v0.0.2 (2016-02-04)
-------------------
- Removed cookbooks directory from repo

v0.0.1 (2016-02-04)
-------------------
- Implement version in `CHANGELOG.md`
- Create `CHANGELOG.md`
- Finalize module
- Updates to `outputs.tf`, added more information
- Updates to `variables.tf`, adding descriptions

33mb9e2aa0 (2016-02-04)
-------------------
- Fixed old chef exec command hanging around
- Fixed IPTables issues; flush then set complete rule set

33m14b29b9 (2016-02-04)
-------------------
- Fixing references to aws_instance provider items

33m5bc32bc (2016-02-04)
-------------------
- removed cookbooks directory file sync
- execute chef server creation directly at server
- create first user
- create first org
- associate user to org
- download user pem
- download org validator pem

33m954a88d (2016-02-04)
-------------------
- fix bulleted list

33ma4c360c (2016-02-04)
-------------------
- Supported OSes
- more assumptions

33m2879244 (2016-02-04)
-------------------
- Delete email linking

33me856561 (2016-02-04)
-------------------
- Correcting e-mail link for Brian Menges

33m8b5553f (2016-02-04)
-------------------
- Correcting linking syntax for users

33m1077c11 (2016-02-04)
-------------------
- Correcting linking syntax

33me261f30 (2016-02-04)
-------------------
- Updating README.md
- More explanation about how to use this module

33mb66e077 (2016-02-03)
-------------------
- moved connection outside of the provisioners per @afiune recommendation
- Added TODO to get rid of the provisioner file hack
- creative addition of git package supporting CentOS and Ubuntu

33m3015e80 (2016-02-03)
-------------------
- SPELLING!

33m4a9a5eb (2016-02-03)
-------------------
- Fixing org to chef_org

33m2440c7c (2016-02-03)
-------------------
- Mixed up region and vpc

33m5475d18 (2016-02-03)
-------------------
- Removing AMI magic
- Getting too complex, simplifying things

33m3a1a2b0 (2016-02-02)
-------------------
- Fixed ami reference, using lookup now

33m3f76ee1 (2016-02-02)
-------------------
- Initial commit

33mc5e5f07 (2016-02-02)
-------------------
- Create repo
