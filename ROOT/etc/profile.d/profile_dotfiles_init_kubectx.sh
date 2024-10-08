#!/bin/bash
# https://github.com/ahmetb/kubectx
KUBECTX_PATH=${HOME}/github/kubectx
if [[ -d "$KUBECTX_PATH" ]]; then
  if command -v kubens >/dev/null 2>&1; then
    source "${KUBECTX_PATH}/completion/kubens.bash"
  fi

  if command -v kubectx >/dev/null 2>&1; then
    source "${KUBECTX_PATH}/completion/kubectx.bash"
  fi
fi
