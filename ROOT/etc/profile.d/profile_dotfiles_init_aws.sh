#!/bin/bash
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
if command -v aws_completer >/dev/null 2>&1; then
    complete -C "$HOME/.asdf/shims/aws_completer" aws
fi

fi
