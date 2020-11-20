#!/bin/bash
# https://github.com/stern/stern
if command -v stern >/dev/null 2>&1
then
    source /usr/share/bash-completion/bash_completion
    source <(stern --completion=bash)
fi
