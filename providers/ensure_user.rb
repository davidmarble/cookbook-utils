require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :ensure do
    username = @new_resource.username
    
    userexists = false
    begin
        p = shell_out!("egrep -i '^#{username}' /etc/passwd")
        userexists = p.stdout.strip().length > 0
    rescue Chef::Exceptions::ShellCommandFailed
    end

    if not userexists or @new_resource.update_if_exists == true
    
        if @new_resource.userinfo
            userinfo = @new_resource.userinfo
            userinfo.each_pair do |key, value|
                @new_resource.instance_variable_set("@#{key}", value)
            end
        end

        if @new_resource.home
            userdir = @new_resource.home
        else
            if username == "root"
                userdir = "/root"
            else
                # Get default home directory
                begin
                    p = shell_out!("grep ^HOME= /etc/default/useradd")
                    userhome = p.stdout.gsub("HOME=","").strip().chomp.strip()
                    if userhome.length < 1
                        userhome = "/home"
                    end
                rescue #Chef::Exceptions::ShellCommandFailed
                    userhome = "/home"
                end
                
                userdir = userhome + "/" + username
            end
        end
        
        disabled = @new_resource.disabled
        shell = disabled ? "/sbin/nologin" : @new_resource.shell ? @new_resource.shell : "/bin/bash"
        comment = @new_resource.full_name ? @new_resource.full_name : username
        shadow_password = @new_resource.password.match(/^\$/) ? @new_resource.password : nil
        uid = @new_resource.uid
        system = @new_resource.system
        key = @new_resource.key
        pubkey = @new_resource.pubkey
        email = @new_resource.email
        ssh_agent = @new_resource.ssh_agent
        
        # If modifying a system user to be a non-system user, create path
        if userexists and not system
            directory "#{userdir}" do
                owner username
                group username
                mode "0700"
            end
        end
        
        # Create or update depending if user exists
        user username do
            shell shell
            comment comment
            home userdir
            uid uid
            gid uid
            password shadow_password
            supports :manage_home => !disabled
            system system
            action userexists ? :manage : :create
        end
        
        password = @new_resource.password.match(/^\$/) ? "" : @new_resource.password
        # Change plain-text password 
        if password.length > 0
            script "Change password for user #{username}" do
                interpreter "bash"
                user "root"
                code <<-EOF
                echo #{username}:#{password} | chpasswd
                EOF
            end
        end
        
        if !disabled and !system
            template "#{userdir}/.bashrc" do
                source "home/bashrc.erb"
                owner username
                group username
                mode "0644"
                cookbook "utils"
                action :create_if_missing
                # not_if "test -f #{userdir}/.bashrc"
            end

            template  "#{userdir}/.aliases" do
                source "home/aliases.erb"
                owner username
                group username
                mode "0644"
                variables(
                    :sudo => username=="root" ? "" : "sudo "
                )
                cookbook "utils"
            end

            template  "#{userdir}/.bash_profile" do
                source "home/bash_profile.erb"
                owner username
                group username
                mode "0644"
                cookbook "utils"
            end

            directory "#{userdir}/.ssh" do
                owner username
                group username
                mode "0700"
            end

            if key
                file "#{userdir}/.ssh/id_rsa" do
                    owner username
                    group username
                    mode "0600"
                    content key
                end
            end
            
            if pubkey
                file "#{userdir}/.ssh/authorized_keys" do
                    owner username
                    group username
                    mode "0600"
                    content pubkey
                end
                file "#{userdir}/.ssh/id_rsa.pub" do
                    owner username
                    group username
                    mode "0600"
                    content pubkey
                end
            end
            
            cookbook_file "#{userdir}/.ssh/config" do
                source "home/dotssh/config"
                owner username
                group username
                mode "0600"
                cookbook "utils"
                action :create_if_missing
                # not_if { ::FileTest.exists?("#{userdir}/.ssh/config") }
            end
            
            if @new_resource.email
                template "#{userdir}/.gitconfig" do
                    source "home/gitconfig.erb"
                    owner username
                    group username
                    mode "0644"
                    variables(
                        :name => comment,
                        :email => email
                    )
                    cookbook "utils"
                    action :create_if_missing
                    # not_if { ::FileTest.exists?("#{userdir}/.gitconfig") }
                end
                
                template "#{userdir}/.hgrc" do
                    source "home/hgrc.erb"
                    owner username
                    group username
                    mode "0644"
                    variables(
                        :name => comment,
                        :email => email
                    )
                    cookbook "utils"
                    action :create_if_missing
                    # not_if { ::FileTest.exists?("#{userdir}/.hgrc") }
                end
            end
        end
        
        # Ensure group with username exists
        utils_ensure_group username do
            members [username]
        end    
    end
end

