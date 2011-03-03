include_recipe "build-essential"

package "openssl-devel"
package "curl"

bash "install nodejs from source" do
  cwd "/usr/local/src"
  user "root"
  code <<-EOH
    set -e
    mkdir -p node-v#{node[:nodejs][:version]}
    cd node-v#{node[:nodejs][:version]}
    curl -L http://nodejs.org/dist/node-v#{node[:nodejs][:version]}.tar.gz | tar xzf - --strip-components=1
    ./configure --prefix=#{node[:nodejs][:dir]}
    make
    make install
  EOH
  environment "PATH" => node[:nodejs][:env_path]
  not_if "#{node[:nodejs][:dir]}/bin/node -v 2>&1 | grep 'v#{node[:nodejs][:version]}'"
end
