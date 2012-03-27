require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :enable do
    package "acl"

    # Enable acl for filesystem where directory resides if not enabled yet
    #
    # Find which file system directory is on
    # If acl is not shown as enabled for this file system
    # Store the mount options for the file system
    # Add 'acl' to those options
    # Re-mount that file system

    # Chef::Log.info("Enable ACL on file system where #{@new_resource.directory} resides")
    
    dir = @new_resource.directory

    p = shell_out!("df -P #{dir} | tail -1 | cut -d' ' -f 1")
    acl_fs = p.stdout.strip()
    p = shell_out!("df -P #{dir} | tail -1 | awk '{print $6}'")
    mounted_on = p.stdout.strip()
    mounted_on_regex = mounted_on.gsub("\/", "\\/")
    
    if acl_fs.match(/^\/dev\/mapper\//)
        fstab_entry = acl_fs.gsub("dev\/mapper\/", "dev\/").gsub("-", "\/")
    else
        fstab_entry = acl_fs
    end
    fstab_regex = fstab_entry.gsub("\/", "\\/")
    
    script "Enable ACL on fstab entry #{fstab_entry} for #{dir}" do
        interpreter "bash"
        user "root"
        code <<-EOF
        if ! mount | grep "#{acl_fs}" | grep -q acl; then
            to_replace=`egrep "#^{fstab_entry}|.* #{mounted_on} " /etc/fstab | awk '{print $4}'`
            sed -i -r 's/(#{fstab_regex}.*|.* #{mounted_on_regex} .*)$to_replace/\1acl,$to_replace/' /etc/fstab
            mount -o rw,acl,remount `egrep "#^{fstab_entry}|.* #{mounted_on} " /etc/fstab | awk '{print $2}'`
        fi
        EOF
    end

    # Make fixperms script available
    template "/usr/local/bin/fixperms" do
        source "fixperms.erb"
        owner "root"
        group "root"
        mode "0755"
        cookbook "utils"
    end
end
