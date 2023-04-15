# rewrite auto-generated /etc/hosts file's kubernetes.docker.internal to point to the host's IP
ip=$(cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2-)
if ! (( $(grep -c . <<<"$ip") > 1 )); then
  # wsl2 will enter this section. wsl1 will not (ipv4 & ipv6 entry found).
  sudo sed -i "/kubernetes\.docker\.internal/ s/.*/$ip\tkubernetes\.docker\.internal/g" /etc/hosts
fi
