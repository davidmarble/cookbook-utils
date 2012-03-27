case node.platform
when "debian", "ubuntu"
    template "/etc/sysctl.conf" do
        source "etc/debian.sysctl.conf.erb"
        owner "root"
        group "root"
        mode 0644
        variables(
            :shmmax => node[:sysctl][:shmmax_mb].to_i*1024*1024,
            :shmall => (node[:sysctl][:shmmax_mb].to_i*1024*1024)/4096
        )
    end
when "redhat", "centos", "fedora"
    template "/etc/sysctl.conf" do
        source "etc/redhat.sysctl.conf.erb"
        owner "root"
        group "root"
        mode 0644
        variables(
            :shmmax => node[:sysctl][:shmmax_mb].to_i*1024*1024,
            :shmall => (node[:sysctl][:shmmax_mb].to_i*1024*1024)/4096
        )
    end
end

execute "sudo sysctl -p" do
    action :run
end
