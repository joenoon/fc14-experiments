ruby_block "yum - 10gen refresh" do
  block do
    Chef::Provider::Package::Yum::YumCache.instance.reload rescue nil
  end
  action :nothing
end

template "/etc/yum.repos.d/10gen.repo" do
  source "10gen.repo.erb"
  variables :arch => node[:mongodb][:arch]
  notifies :create, resources(:ruby_block => "yum - 10gen refresh"), :immediately
end

[ node[:mongodb][:client], node[:mongodb][:server] ].each do |x|
  package x do
    action :install
    options "--enablerepo=10gen"
  end
end

[ node[:mongodb][:client], node[:mongodb][:server] ].each do |x|
  package x do
    action :upgrade
    options "--enablerepo=10gen"
  end
end
  
service "mongod" do
  supports [ :status, :restart, :reload, :start, :stop ]
  action [ :enable, :start ]
end
