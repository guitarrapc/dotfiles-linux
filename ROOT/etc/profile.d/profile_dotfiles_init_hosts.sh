# rewrite auto-generated /etc/hosts file's kubernetes.docker.internal to point to the host's IP
ip=$(cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2-)
if (( $(grep -c . <<<"$ip") > 1 )); then
    # wsl will enter this section.
    echo skipping /etc/hosts rewrite because multiple nameservers found
else
    # wsl2 will enter this section.
    sed -i "/kubernetes\.docker\.internal/ s/.*/$ip\tkubernetes\.docker\.internal/g" /etc/hosts
fi
