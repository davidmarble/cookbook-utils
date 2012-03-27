# Disable cert checking for everyone for mercurial (git is done per-user)
directory "/etc/mercurial/hgrc.d" do
    action :create
    owner "root"
    group "root"
    mode "0755"
    recursive true
end

cookbook_file "/etc/mercurial/hgrc.d/no-cacerts.rc" do
    owner "root"
    group "root"
    mode "0644"
    source "etc/mercurial/hgrc.d/no-cacerts.rc"
end
