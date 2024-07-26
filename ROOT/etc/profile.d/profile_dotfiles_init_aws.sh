#!/bin/bash
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
if command -v aws_completer >/dev/null 2>&1; then
    complete -C "$HOME/.asdf/shims/aws_completer" aws
fi

# https://github.com/99designs/aws-vault/blob/90c6834e431769acbeb13223dcae996923b8820e/contrib/docker/Dockerfile#L4
if command -v aws-vault >/dev/null 2>&1; then
    export AWS_VAULT_BACKEND=file
fi
