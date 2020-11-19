#!/bin/bash
# https://github.com/ahmetb/kubectx
KUBECTX_PATH=${HOME}/github/kubectx
COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
ln -sf ${KUBECTX_PATH}/completion/kubens.bash $COMPDIR/kubens
ln -sf ${KUBECTX_PATH}/completion/kubectx.bash $COMPDIR/kubectx
