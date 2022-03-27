# Bash
alias ls='ls -F'
alias h=history
alias tm=mate
alias e=edit
alias f=find-name
alias o=open

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

source ~/.bash/functions/*

#
# prompt
#
if [[ $HOSTNAME == "ookla.local" || $HOSTNAME == "base.local" ]]; then
  colorOn='\[\033[35m\]'    # Magenta
  colorOn='%F{magenta}'
else
  colorOn='\[\033[36m\]'    # Cyan
  colorOn='%F{cyan}'
fi

# Color off
colorOff='\[\033[0m\]'
colorOff='%f'

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

function set-title-pwd {
  set-title $(basename $PWD)
}

if [[ "$ITERM_PROFILE" == "Hotkey Window" ]]; then
  PS1="> "
else
  setopt PROMPT_SUBST
  PS1="$colorOn%n@%m:"'$(cwd_physical_short)'$'\n''$(git_branch) '"$colorOff"
  # PS1+='$(set-title-pwd)'

  # show exit code of last command
  # PS1='%(?.√.?%?) '$PS1 
fi
export PS1
