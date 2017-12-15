# Bash
alias ls='ls -F'
alias h='history'
alias tm='mate'
alias e='edit'
alias py='python'
alias pyd='python -m pdb'
alias mg='py manage.py'

setup() {
    cwd=`pwd`
    for fn in `findup .setup`; do
        source $fn
    done
    cd $cwd
}

# Search functions
search-functions() {
  if [ "$1" ]; then lessOption="-p $1"; fi
  declare -f | less $lessOption
}

if [[ $HOSTNAME == "ookla.local" || $HOSTNAME == "base.local" ]]; then
  colorOn='\[\033[35m\]'    # Magenta
else
  colorOn='\[\033[36m\]'    # Cyan
fi

# Color off
colorOff='\[\033[0m\]'

function cwd_physical_short() {
  local p=$(pwd -P)
  echo ${p/$HOME/\~}
}
function git_branch() {
  local line=$(git status 2>/dev/null | grep 'On branch')
  if [ -n "$line" ]; then
    echo -e "$line\n$"
  else
    echo "$"
  fi
}

if [ "$ITERM_PROFILE" == "Hotkey Window" ]; then
  PS1="> "
else
  PS1="$colorOn\u@\h:"'$(cwd_physical_short)\n$(git_branch) '"$colorOff"
fi
export PS1
