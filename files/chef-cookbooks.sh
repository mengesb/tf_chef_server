#!/usr/bin/env bash
sudo rm -rf /var/chef/cookbooks ; sudo mkdir -p /var/chef/cookbooks
for DEP in apt apt-chef chef-client        ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in chef-ingredient chef-server     ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in chef-sugar cron firewall        ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in hostsfile logrotate packagecloud; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in system yum yum-chef windows     ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
sudo chown -R root:root /var/chef/cookbooks
echo Finished
