gem_package 'remote_syslog' do
    action :install
end

template '/etc/log_files.yml' do
    source 'log_files.yml.erb'
    owner 'root'
    group 'root'
    mode 00644
    variables(
      :logs => node['remote_syslog']['log_files']
    )
    action :create
end

cookbook_file '/etc/init.d/remote_syslog' do
	source 'remote_syslog'
	owner 'root'
	group 'root'
    mode 00744
end

service 'remote_syslog' do
    init_command '/etc/init.d/remote_syslog'
    provider Chef::Provider::Service::Init::Debian
    supports :status => true, :start => true, :stop => true, :restart => true
    action [ :enable, :start ]
end
