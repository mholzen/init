function cdr() {
  root=`findup .git | xargs dirname`
  if [ ! -z "$root" ]; then
    cd $root
  fi
}

alias gs='git status'
alias gb='git branch'
alias gd='git diff'
alias gdc='git diff --cached'
alias gp='git push'
alias co='git checkout'
