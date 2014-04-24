pkgs = [ 'build-essential', 'libssl-dev', 'ruby-dev' ]
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

case node['platform']
when 'ubuntu'
    unless node['platform_version'].to_f >= 13.10
        package "rubygems" do
            action :install
        end
    end
end

gem_package 'remote_syslog' do
    action :install
end

cookbook_file '/etc/init.d/remote_syslog' do
    source 'remote_syslog'
    owner 'root'
    group 'root'
    mode 00744
end

service 'remote_syslog' do
    provider Chef::Provider::Service::Init::Debian
    supports :status => true, :start => true, :stop => true, :restart => true
    action [ :enable, :start ]
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
    notifies :restart, "service[remote_syslog]", :delayed
end
