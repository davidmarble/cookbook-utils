if ["debian", "ubuntu"].include?(node.platform)
    script "Create flyer user" do
        interpreter "bash"
        user "root"
        code <<-EOH
if ! /bin/grep -q timeout=-1 /etc/grub.d/00_header; then
    sudo sed -i -r 's/timeout=-1/timeout=2/' /etc/grub.d/00_header
    update-grub2
fi
        EOH
    end
end
