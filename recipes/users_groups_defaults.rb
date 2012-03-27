# /etc/profile, /etc/bash.bashrc (debian, ubuntu), /etc/bashrc (redhat, centos)
case node.platform
when "redhat", "centos"
    template "/etc/profile" do
        source "etc/redhat.profile.erb"
        owner "root"
        group "root"
        mode "0644"
    end
    template "/etc/bashrc" do
        source "etc/bashrc.erb"
        owner "root"
        group "root"
        mode "0644"
    end
when "debian", "ubuntu"
    template "/etc/profile" do
        source "etc/debian.profile.erb"
        owner "root"
        group "root"
        mode "0644"
    end
    template "/etc/bash.bashrc" do
        source "etc/bashrc.erb"
        owner "root"
        group "root"
        mode "0644"
    end
end

template "/etc/skel/.bashrc" do
    source "home/bashrc.erb"
    owner "root"
    group "root"
    mode "0644"
end

template "/etc/skel/.aliases" do
    source "home/aliases.erb"
    owner "root"
    group "root"
    mode "0644"
end

if node.attribute?("additional_users")
    usrs = {}.merge(node[:users]).merge(node[:additional_users])
else
    usrs = {}.merge(node[:users])
end

usrs.each_pair do |username, userinfo|
    utils_ensure_user username do
        userinfo userinfo
    end
end

node[:groups].each_pair do |groupname, groupinfo|
    utils_ensure_group groupname do
        groupinfo groupinfo
    end
end


