if node.attribute?("all_servers")
  template "/etc/hosts" do
    source "etc/hosts"
    mode "644"
    variables :all_servers => node[:all_servers] || {}
  end
end
