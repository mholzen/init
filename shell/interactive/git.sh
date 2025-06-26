function cdr() {
  root=`findup .git | xargs dirname`
  if [ ! -z "$root" ]; then
    cd $root
  fi
}

# Configure git editor based on environment
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    # When in VSCode terminal, use VSCode as git editor
    export GIT_EDITOR="cursor --wait"
fi

alias gs='git status'
alias gb='git branch'
alias gd='git diff'
alias gdc='git diff --cached'
alias gp='git push'
alias co='git checkout'
