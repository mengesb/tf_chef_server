{
  "fqdn": "${host}.${domain}",
  "chef-server": {
    "api_fqdn": "${host}.${domain}",
    "topology": "standalone",
    "addons": [
      "manage",
      "reporting",
      "push-server"
    ],
    "configuration": "nginx['ssl_certificate'] = '/var/chef/ssl/${host}.${domain}.pem'\nnginx['ssl_certificate_key'] = '/var/chef/ssl/${host}.${domain}.key'"
  },
  "firewall": {
    "allow_established": true,
    "allow_ssh": true
  },
  "system": {
    "short_hostname": "${host}",
    "domain_name": "${domain}",
    "manage_hostsfile": true
  },
  "tags": []
}

