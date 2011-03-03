set_unless[:hummingbird][:install_path] = "/home/vagrant/hummingbird"
set_unless[:hummingbird][:owner] = "vagrant"
set_unless[:hummingbird][:group] = "vagrant"
set_unless[:hummingbird][:config] = JSON.pretty_generate({
  :name => "Hummingbird",
  :tracking_port => 8000,
  :dashboard_port => 8080,
  :mongo_host => "localhost",
  :mongo_port => 27017,
  :enable_dashboard => true,
  :capistrano => {
    :repository => "git://github.com/mnutt/hummingbird.git",
    :hummingbird_host => "hummingbird.your-host.com"
  }
})
