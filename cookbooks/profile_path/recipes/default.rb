template "/etc/profile.d/profile_path.sh" do
  source "profile_path.sh.erb"
  mode "0644"
  variables :hard_set => node[:profile_path][:hard_set], :path => node[:profile_path][:path]
  backup false
end
