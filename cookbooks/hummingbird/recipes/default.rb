require_recipe "mongodb"
require_recipe "nodejs::npm"
require_recipe "bluepill"

package "git"
package "patch"

execute "git clone git://github.com/mnutt/hummingbird.git #{node[:hummingbird][:install_path]}" do
  user node[:hummingbird][:owner]
  group node[:hummingbird][:group]
  not_if "test -e #{node[:hummingbird][:install_path]}"
end

execute "gunzip-geo" do
  command "gunzip GeoLiteCity.dat.gz"
  cwd node[:hummingbird][:install_path]
  user node[:hummingbird][:owner]
  group node[:hummingbird][:group]
  action :nothing
end
  
remote_file "#{node[:hummingbird][:install_path]}/GeoLiteCity.dat.gz" do
  source "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
  notifies :run, resources(:execute => "gunzip-geo"), :immediately
  owner node[:hummingbird][:owner]
  group node[:hummingbird][:group]
  not_if "test -e #{node[:hummingbird][:install_path]}/GeoLiteCity.dat"
end

execute "install - hummingbird npm bundle" do
  command "npm bundle install"
  cwd node[:hummingbird][:install_path]
  user node[:hummingbird][:owner]
  group node[:hummingbird][:group]
  environment "PATH" => node[:nodejs][:env_path]
  not_if "test -e #{node[:hummingbird][:install_path]}/node_modules"
end

cookbook_file "/usr/local/src/node_modules.patch" do
  source "node_modules.patch"
  mode "0777"
end

execute "patch hummingbird for node_modules" do
  command "(patch -p0 -f -s --no-backup-if-mismatch </usr/local/src/node_modules.patch) || true"
  cwd node[:hummingbird][:install_path]
  user node[:hummingbird][:owner]
  group node[:hummingbird][:group]
end

execute "rm -rf #{node[:hummingbird][:install_path]}/server.js.*"

bluepill_monitor "hummingbird" do
  cookbook "hummingbird"
  source "hummingbird.conf.erb"
  install_path node[:hummingbird][:install_path]
end

template "#{node[:hummingbird][:install_path]}/config/app.json" do
  source "app.json.erb"
  variables :config => node[:hummingbird][:config]
  owner node[:hummingbird][:owner]
  group node[:hummingbird][:group]
  mode "0644"
  notifies :run, resources("execute[restart-bluepill-hummingbird]")
end
