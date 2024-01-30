#!/bin/bash
echo 'export GOPATH=$HOME' > $HOME/.go
echo 'export PATH=$PATH:$HOME/go/bin' >> $HOME/.go
echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.go

source $HOME/.go
