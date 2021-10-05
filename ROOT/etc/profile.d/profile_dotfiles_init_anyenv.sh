#!/bin/bash
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
if [[ -d "${HOME}/.anyenv" ]]; then
    if command -v anyenv 1>/dev/null 2>&1; then
        eval "$(anyenv init -)"
    fi
fi
