{
  "fqdn": "${host}.${domain}",
   "chef_client": {
     "init_style": "none"
   },
  "chef-server": {
    "addons": [
      "manage",
      "push-server",
      "reporting"
    ],
    "api_fqdn": "${host}.${domain}",
    "configuration": "nginx['ssl_certificate'] = '/var/chef/ssl/${host}.${domain}.pem'\nnginx['ssl_certificate_key'] = '/var/chef/ssl/${host}.${domain}.key'",
    "topology": "standalone"
  },
  "firewall": {
    "allow_established": true,
    "allow_ssh": true
  },
  "system": {
    "delay_network_restart": false,
    "domain_name": "${domain}",
    "manage_hostsfile": true,
    "short_hostname": "${host}"
  },
  "tags": []
}
