#!/bin/bash
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
if command -v kubectl >/dev/null 2>&1; then
    source /usr/share/bash-completion/bash_completion
    source <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
fi
