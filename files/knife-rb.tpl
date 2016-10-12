current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                '${user}'
client_key               "#{current_dir}/${user}.pem"
chef_server_url          'https://${fqdn}/organizations/${org}'
cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/checksums" )
cookbook_path            ["#{current_dir}/local-mode-cache/cache/cookbooks"]
