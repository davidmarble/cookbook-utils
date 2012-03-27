script "Use Google DNS" do
    interpreter "bash"
    user "root"
    cwd "/etc/dhcp"
    # Debian-specific:
    code <<-EOH
    echo 'prepend domain-name-servers 8.8.8.8, 8.8.4.4;' >> /etc/dhcp/dhclient.conf
    /etc/init.d/networking restart
    EOH
    not_if "grep '8.8.8.8' /etc/dhcp/dhclient.conf"
end
