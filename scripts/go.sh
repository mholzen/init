export PATH="/usr/local/go/bin:$PATH"

# export GOPATH="${HOME}/.go" # update path as wanted
# export GOROOT="$(brew --prefix golang)/libexec"
# export GOROOT="/usr/local/opt/go/libexec"
export GOROOT="/usr/local/go/"
export GOPRIVATE="github.com/teamookla/*" # required with v >1.13
# export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
