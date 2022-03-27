#
# Colors
#
if [[ $HOSTNAME == "ookla.local" || $HOSTNAME == "base.local" ]]; then
  colorOn='\[\033[35m\]'    # Magenta
  colorOn='%F{magenta}'
else
  colorOn='\[\033[36m\]'    # Cyan
  colorOn='%F{cyan}'
fi

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

function prompt-simple { ps1-simple }
function prompt-color { ps1-color }
function prompt-dollar-color { ps1-dollar-color }
function prompt-directory { ps1-directory }

function prompt { ps1-directory }