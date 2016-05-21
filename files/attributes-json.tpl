{
  "fqdn": "${host}.${domain}",
   "chef_client": {
     "init_style": "none"
   },
  "chef-server": {
    "accept_license": ${license},
    "addons": [${addons}],
    "api_fqdn": "${host}.${domain}",
    "configuration": "nginx['ssl_certificate'] = '/var/chef/ssl/${host}.${domain}.pem'\nnginx['ssl_certificate_key'] = '/var/chef/ssl/${host}.${domain}.key'",
    "topology": "standalone",
    "version": "${version}"
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
