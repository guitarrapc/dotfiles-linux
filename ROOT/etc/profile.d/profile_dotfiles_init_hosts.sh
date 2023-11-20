#!/bin/bash
is_wsl2=$(cat /proc/version | grep -c microsoft-standard)

if [[ "$is_wsl2" == "1" ]]; then
    # WSL2 should Rewrite auto-generated /etc/hosts file's kubernetes.docker.internal to point to the host's IP
    # WSL1 don't need this.
    ip=$(cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2-)
    if ! (( $(grep -c . <<<"$ip") > 1 )); then
    sudo sed -i "/kubernetes\.docker\.internal/ s/.*/$ip\tkubernetes\.docker\.internal/g" /etc/hosts
    fi
fi
