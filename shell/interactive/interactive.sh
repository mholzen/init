# define word boundary for backward-kill-word
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

## consider
### autoload -U select-word-style
### select-word-style bash


# Other files
for f in $HOME/.init/shell/functions/*; do
  source $f
done

# Search functions
alias get-functions='declare -f'
alias functions=get-functions
search-functions() {
  if [ "$1" ]; then lessOption="-p $1"; fi
  declare -f | less $lessOption
}


# iTerm2
function set-title-pwd {
  set-title $(basename $PWD)
}


