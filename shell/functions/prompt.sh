#
# Colors
#
export COLOR_NC='\e[0m' # No Color
export COLOR_BLACK='\e[0;30m'
export COLOR_GRAY='\e[1;30m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_LIGHT_GRAY='\e[0;37m'
export COLOR_WHITE='\e[1;37m'

if [[ $HOSTNAME == "base.local" ]]; then
  colorOn='\[\033[35m\]'    # Magenta
  colorOn='%F{magenta}'
  # colorOn=$COLOR_PRUPLE
else
  colorOn='\[\033[36m\]'    # Cyan
  colorOn='%F{cyan}'
  # colorOn=$COLOR_CYAN
fi

colorOff='\[\033[0m\]'
colorOff='%f'
# colorOff=$COLOR_NC

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

function ps1-simple { PS1='> '; }
function ps1-color { PS1="$colorOn> $colorOff"; }
function ps1-dollar-color { PS1="$colorOn\$ $colorOff"; }
function ps1-directory { PS1='$colorOn%1d > $colorOff'; }

alias prompt-simple=ps1-simple
alias prompt-color=ps1-color
alias prompt-dollar-color=ps1-dollar-color
alias prompt-directory=ps1-directory

alias prompt=ps1-directory