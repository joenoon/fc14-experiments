%w( ruby rubygems ruby-devel ).each do |x|
  package x do
    action :install
    options "--enablerepo=updates-testing"
  end
end
%w( ruby rubygems ruby-devel ).each do |x|
  package x do
    action :upgrade
    options "--enablerepo=updates-testing"
  end
end
