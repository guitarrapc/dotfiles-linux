# rewrite auto-generated /etc/hosts file's kubernetes.docker.internal to point to the host's IP
ip=$(cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2-)
sed "/kubernetes\.docker\.internal/ s/.*/$ip\tkubernetes\.docker\.internal/g" /etc/hosts
