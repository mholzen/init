# Interactive login       => .bash_profile	=> will source ~/.bash_profile.d/*.sh
# Interactive,non-login   => .bashrc 		=> nothing needed at this point
# Non-interactive         => $BASH_ENV 		=> will source ~/.bash_non_interactive.d/*.sh

export BASH_ENV=~/.bash_non_interactive

for file in ~/.bash_profile.d/*; do
	if [ -r $file ]; then
		source $file;
	fi
done

source $BASH_ENV
