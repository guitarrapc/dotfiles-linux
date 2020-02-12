#!/bin/bash
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
if /usr/local/aws-cli/v2/current/bin/aws_completer >/dev/null 2>&1
then
    complete -C '/usr/local/aws-cli/v2/current/bin/aws_completer' aws
fi
