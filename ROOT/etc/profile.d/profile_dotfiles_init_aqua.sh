#!/bin/bash
if [[ -d "${HOME}/.local/share/aquaproj-aqua/bin" ]]; then
  export PATH="${HOME}/.local/share/aquaproj-aqua/bin:$PATH"
  export AQUA_GLOBAL_CONFIG="$HOME/.config/aquaproj-aqua/aqua.yaml"
fi

if command -v aqua &> /dev/null; then
  # shellcheck disable=SC1090
  source <(aqua completion bash)
fi
