include_recipe "nodejs"

bash "install npm - package manager for node" do
  cwd "/usr/local/src"
  user "root"
  code <<-EOH
    set -e
    mkdir -p npm-v#{node[:nodejs][:npm]}
    cd npm-v#{node[:nodejs][:npm]}
    curl -L http://registry.npmjs.org/npm/-/npm-#{node[:nodejs][:npm]}.tgz | tar xzf - --strip-components=1
    make uninstall dev
  EOH
  environment "PATH" => node[:nodejs][:env_path]
  not_if {File.exists?("/usr/local/bin/npm@#{node[:nodejs][:npm]}")}
end

