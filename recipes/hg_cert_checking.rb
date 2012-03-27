# Copy the proper cert configurations for mercurial
directory "/etc/mercurial/hgrc.d" do
    action :create
    owner "root"
    group "root"
    mode "0755"
    recursive true
end

case node[:platform]
when "debian", "ubuntu"
    cookbook_file "/etc/mercurial/hgrc.d/cacerts.rc" do
        owner "root"
        group "root"
        mode "0644"
        source "etc/mercurial/hgrc.d/cacerts.debian.rc"
    end
when "centos","redhat","fedora"
    cookbook_file "/etc/mercurial/hgrc.d/cacerts.rc" do
        owner "root"
        group "root"
        mode "0644"
        source "etc/mercurial/hgrc.d/cacerts.redhat.rc"
    end
else 
    cookbook_file "/etc/mercurial/hgrc.d/cacerts.rc" do
        owner "root"
        group "root"
        mode "0644"
        source "etc/mercurial/hgrc.d/cacerts.rc"
    end
end
