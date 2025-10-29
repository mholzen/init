# From https://golang.org/doc/install
# GOPATH default is $HOME/go

# `go install places binaries in $GOPATH/bin
export PATH="${PATH}:${HOME}/go/bin"

# From Homebrew
# NOTE: doesn't seen to install the ARM64 version
# export GOROOT="$(brew --prefix golang)/libexec"
# go at /usr/local/bin/go
