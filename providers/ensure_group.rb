require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :ensure do
    groupname = @new_resource.groupname
    
    if @new_resource.groupinfo
        groupinfo = @new_resource.groupinfo
        groupinfo.each_pair do |key, value|
            @new_resource.instance_variable_set("@#{key}", value)
        end
    end
        
    # if group doesn't exist, create it
    # groupexists = `egrep -i "^#{groupname}" /etc/group`
    begin
        p = shell_out!("egrep -i \"^#{groupname}\" /etc/group")
        groupexists = p.stdout.strip().length > 0
    rescue #Chef::Exceptions::ShellCommandFailed
        groupexists = false
    end
    
    gid = @new_resource.gid
    members = @new_resource.members
    
    group groupname do
        gid 
        members members
        append groupexists ? true : false
        action groupexists ? :manage : :create
    end
    
end
