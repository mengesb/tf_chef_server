#!/usr/bin/env bash
curl -sL https://www.chef.io/chef/install.sh | sudo bash
for DEP in apt apt-chef chef-ingredient   ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in chef-server chef-sugar cron    ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in firewall hostsfile packagecloud; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
for DEP in system yum yum-chef            ; do curl -sL https://supermarket.chef.io/cookbooks/${DEP}/download | sudo tar xzC /var/chef/cookbooks; done
echo Finished
