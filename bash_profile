# Interactive login       => .bash_profile	=> will source ~/.bash_profile.d/*.sh
# Interactive,non-login   => .bashrc 		=> nothing needed at this point
# Non-interactive         => $BASH_ENV 		=> removed. Used to source ~/.bash_non_interactive.d/*.sh

for file in ~/.bash/bash_profile.d/*; do
	if [ -f $file ]; then
		source $file;
	fi
done

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
