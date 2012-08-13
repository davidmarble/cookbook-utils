default['acl_dir'] = "/"
# about 100 for every 1MB of ram is a decent ballpark, so 100,000 per 1 GB RAM
default['sysctl']['file_max'] = 100000
default['sysctl']['shmmax_mb'] = 512
