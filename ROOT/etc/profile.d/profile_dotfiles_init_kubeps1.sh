#!/bin/bash
# https://github.com/jonmosco/kube-ps1
KUBECTX_PATH=${HOME}/github/kube-ps1
if [[ -d "${KUBECTX_PATH}" ]]
then
    source ${KUBECTX_PATH}/kube-ps1.sh
    PS1='[\u@\h \W $(kube_ps1)]\$ '
fi
