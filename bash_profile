# Interactive login       => .bash_profile	=> will source ~/.bash_profile.d/*.sh
# Interactive,non-login   => .bashrc 		=> nothing needed at this point
# Non-interactive         => $BASH_ENV 		=> removed. Used to source ~/.bash_non_interactive.d/*.sh

for file in ~/.bash/bash_profile.d/*; do
	if [ -f $file ]; then
		source $file;
	fi
done

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
