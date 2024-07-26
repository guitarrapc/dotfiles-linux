#!/bin/bash
# https://www.pulumi.com/docs/reference/cli/#command-line-completion
if command -v pulumi >/dev/null 2>&1; then
  source /usr/share/bash-completion/bash_completion
  source <(pulumi gen-completion bash)
fi
