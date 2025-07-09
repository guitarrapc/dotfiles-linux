#!/bin/bash
# see: https://zenn.dev/shunsuke_suzuki/articles/aqua-nodejs-support
export NPM_CONFIG_PREFIX=${XDG_DATA_HOME:-$HOME/.local/share}/npm-global
export PATH=$NPM_CONFIG_PREFIX/bin:$PATH
