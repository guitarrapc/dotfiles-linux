#!/bin/bash
echo 'export GOPATH=$HOME' > $HOME/.profile
echo 'export PATH=$PATH:$HOME/go/bin' >> $HOME/.profile
echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.profile

source $HOME/.profile
