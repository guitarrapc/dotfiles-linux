#!/bin/bash
# ansible can't reload from .bashrc_custom, but profile can reloaded.
# https://asdf-vm.com/guide/getting-started.html#community-supported-download-methods
if [[ -d "${HOME}/.asdf" ]]; then
    source "${HOME}/.asdf/asdf.sh"
    source "${HOME}/.asdf/completions/asdf.bash"
fi
