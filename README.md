# Description

Utility providers and recipes for use in chef cookbooks.

**NOTE:** Make sure to rename this to `utils` if you clone it or incorporate 
it as a git submodule in your cookbooks.

# Contents and Usage

## Providers

### utils_acl

Ensures ACL is enabled on the filesystem where the passed in directory resides.

Example:

    utils_acl "/"

### utils_ensure_user

Ensures a user exists with the attributes passed in. Also ensures a group 
exists with the given username. Uses templates to add `~/.bashrc`, 
`~/.bash_profile`, `~/.aliases`, `~/.ssh/config`. If `key` is defined, adds 
`~/.ssh/id_rsa`. If `pubkey` is defined, adds `~/.ssh/id_rsa.pub` and 
`~/.ssh/authorized_keys`. If `email` is defined, adds `~/.gitconfig` and 
`~/.hgrc`. See `templates/` to customize these default files.

Example:

    utils_ensure_user "bob" do
        email "bob@example.com"
        password "unsecure-but-works"
    end

Attributes:

* `username` (string) - defined in provider call ("www-data" above)
* `shell` (string, default="/bin/bash")
* `full_name` (string, default=username)
* `home` (string, optional) - if ommitted, determined automatically
* `uid` (Integer, optional)
* `system` (default=false)
* `disabled` (default=false) - if true, shell is set to /sbin/nologin
* `key` (string, optional) - private SSH key
* `pubkey` (string, optional) - public SSH key
* `email` (string, optional) - for .gitconfig and .hgrc
* `ssh_agent` (default=false) - enables ssh_agent on login
* `password` (string, optional) - can be plain-text or shadow
* `userinfo` (hash, optional) - an optional way to pass in all of the above.
* `update_if_exists` (default=true) - update the user if they already exist.
* `dotfiles_if_exists` (default=false) - give the user copies of dotfiles if the user already exists.

### utils_ensure_group

Ensures a group exists with the attributes passed in. The members must already 
exist on the system.

Example:

    utils_ensure_group "www-pub" do
        members ["bob", "jane"]
    end

Attributes:

* `groupname` (string) - defined in provider call ("www-pub" above)
* `gid` (integer, optional) - group id
* `members` (array of strings, optional) - members to include in the group.
* `groupinfo` (hash, optional) - an optional way to pass in the above


## Recipes

### utils::disable_hg_cert_checking

Disable cert checking for all users for mercurial. Note that there's no 
system-wide way to disable git cert checking, because it's done per-user.

### utils::enable_acl

Enable ACL on the root filesystem. This uses the utils_acl provider, which 
may have some issues depending on the platform.

### utils::google_dns

**Debian/Ubuntu only currently**. Uses Google DNS servers first. 

### utils::grub_timeout

**Debian/Ubuntu only**. By default, GRUB under Debian and Ubuntu can get stuck 
on reboot because of a -1 timeout setting. This makes the default 2 seconds.

### utils::hg_cert_checking

Copy the proper cert configurations for mercurial. Not really tested.

### utils::hosts

Create a `/etc/hosts` file based on pairs of IP address and hostname line 
defined in node[:all_servers].

### utils::sysctl

Set proper shmmax and shmall values in `/etc/sysctl.conf` by setting 
node[:sysctl][:shmmax_mb]. These will be applied on the host immediately.

### utils::users_groups_defaults

Set default /etc/profile, bashrc, and aliases based on platform. Edit the 
templates in `templates/` to change defaults. 

This recipe also takes care of creating/updating users defined in 
`node[:users]` and `node[:additional_users]`, and groups defined in 
`node[:groups]`. See utils_ensure_user and utils_ensure_group for how they 
work.


# License and Author

Author:: David Marble (<davidmarble@gmail.com>)

Copyright:: 2012, David Marble

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
