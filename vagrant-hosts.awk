# this simple awk script reads an ssh-config from `vagrant ssh-config` and 
# converts it to an ansible inventory file.

BEGIN { print "[vagrant]" }

/^Host / { host=$2 } 
/HostName/ {ip=$2} 
/Port/ { port=$2 } 
/^[[:space:]]+User[[:space:]]+/ { user=$2 } 
/IdentityFile/ { keyfile=$2 } 
/^$/ { printf "%s ansible_ssh_host=%s ansible_ssh_port=%s ansible_ssh_user=%s ansible_ssh_private_key_file=%s\n", host, ip, port, user, keyfile }
