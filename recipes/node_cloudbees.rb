include_recipe "runit"
include_recipe "apt"
include_recipe "java"

service_name = "cloudbees-jenkins-slave"
slave_jar = "#{node[:jenkins][:node][:home]}/slave.jar"

group node[:jenkins][:node][:user] do
end

user node[:jenkins][:node][:user] do
  comment "Jenkins CI node (cloudbees)"
  gid node[:jenkins][:node][:user]
  home node[:jenkins][:node][:home]
  shell "/bin/bash"
end

directory node[:jenkins][:node][:home] do
  action :create
  owner node[:jenkins][:node][:user]
  group node[:jenkins][:node][:user]
end

directory "#{node[:jenkins][:node][:home]}/.ssh" do
  action :create
  owner node[:jenkins][:node][:user]
  group node[:jenkins][:node][:user]
end


file "#{node[:jenkins][:node][:home]}/.ssh/cloudbees" do
  action :create
  owner node[:jenkins][:node][:user]
  group node[:jenkins][:node][:user]
  content node[:jenkins][:node][:private_ssh_key]
  mode '0600'
end

#jenkins_cli "-i #{node[:jenkins][:node][:home]}/.ssh/id_rsa customer-managed-slave -fsroot #{node[:jenkins][:node][:home]} -labels #{node[:jenkins][:node][:labels]} -name #{node[:jenkins][:node][:name]}&" do
jenkins_cli "-i #{node[:jenkins][:node][:home]}/.ssh/id_rsa who-am-i -fsroot #{node[:jenkins][:node][:home]} -labels #{node[:jenkins][:node][:labels]} -name #{node[:jenkins][:node][:name]}&"

runit_service service_name



