maintainer        "David Marble"
maintainer_email  "davidmarble@gmail.com"
license           "Apache 2.0"
name              "utils"
description       "chef util recipes and providers"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"

recipe            "base_packages", ""
recipe            "disable_hg_cert_checking", ""
recipe            "enable_acl", ""
recipe            "google_dns", ""
recipe            "grub_timeout", ""
recipe            "hg_cert_checking", ""
recipe            "hosts", ""
recipe            "sysctl", ""
recipe            "users_groups_defaults", ""

%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end