#!/usr/bin/env bash

sudo rm -rf /var/chef/cookbooks ; sudo mkdir -p /var/chef/cookbooks
sudo rm -rf /var/chef/cache     ; sudo mkdir -p /var/chef/cache
sudo rm -rf /var/chef/ssl       ; sudo mkdir -p /var/chef/ssl

for DEP in apt apt-chef chef-client     ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in chef_handler chef-ingredient ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in compat_resource chef-server  ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in chef-sugar cron firewall     ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in hostsfile logrotate          ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in packagecloud system yum      ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in yum-chef windows             ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done

sudo chown -R root:root /var/chef

exit 0
