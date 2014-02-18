default[:remote_syslog][:host] = 'logs.papertrailapp.com'
default[:remote_syslog][:port] = '514'
default[:remote_syslog][:log_files] = ['/var/log/chef/client.log']