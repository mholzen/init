# Interactive login       => .bash_profile	=> will source ~/.bash_profile.d/*.sh
# Interactive,non-login   => .bashrc 		=> nothing needed at this point
# Non-interactive         => $BASH_ENV 		=> removed. Used to source ~/.bash_non_interactive.d/*.sh


# Place this here instead of in bash_profile.d to set precedence over
# macports.sh 

[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh

for file in ~/.bash_profile.d/*; do
	if [ -r $file ]; then
		source $file;
	fi
done
