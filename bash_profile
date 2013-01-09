# Bash
alias h='history'
alias chrome='open -a /Applications/Google\ Chrome.app'
alias edit='open -a /Applications/Sublime\ Text\ 2.app'
alias open-with-chrome='chrome'
alias reveal=which
alias functions='declare -f'
alias python-debug='python -m pdb'
alias debug-python='python-debug'

# Copy the current working directory so that I can paste or use pbpaste with it
alias copy-cwd='echo -n `pwd` | pbcopy'

# Define the prompt as hostname - working directory
export PS1='\h:\W \$ '

# Grails
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
export GRAILS_HOME=/Users/holzen/dev/grails/grails-1.2.0
export PATH=$PATH:$GRAILS_HOME/bin

export LC_CTYPE=en_US.UTF-8

# Python MacPorts
# Mvh: removed because I think it conflicts with virtualenv
#export PYTHONPATH=$PYTHONPATH:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/
#export PYTHONPATH=$PYTHONPATH:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages
#export PYTHONPATH=$PYTHONPATH:$HOME/.use-python
export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/:$PATH

# Python
export PYTHONSTARTUP=$HOME/.pythonstartup.py

# Jetty
export JETTY_HOME=/Users/holzen/dev/jetty-6.1.8/
export PATH=$PATH:$JETTY_HOME/bin

# The following line is automtically inserted by bash-profilename-install
for f in ~/.bash_profile.d/*.sh; do source $f; done
# End of automatic insert

source ~/.use-bash/setup.sh

##
# Your previous /Users/holzen/.bash_profile file was backed up as /Users/holzen/.bash_profile.macports-saved_2010-04-14_at_20:28:39
##

# MacPorts Installer addition on 2010-04-14_at_20:28:39: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi
