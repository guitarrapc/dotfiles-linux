#!/bin/bash
cat << 'EOF'  > "$HOME/.go"
  export GOPATH=$HOME
  export PATH=$PATH:$HOME/go/bin
  export PATH=$PATH:$GOPATH/bin
EOF

source "$HOME/.go"
