#!/bin/bash
# https://github.com/anyenv/anyenv
if [[ -d "${HOME}/.anyenv" ]]; then
    if command -v anyenv 1>/dev/null 2>&1; then
        eval "$(anyenv init -)"
    fi
fi
