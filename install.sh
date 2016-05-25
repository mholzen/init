srcdir="$( cd "$( dirname "$0" )" && pwd )"

mv ~/.bash /tmp && ln -s "$srcdir" ~/.bash
mv ~/.bash_profile /tmp && ln -s ~/.bash/bash_profile ~/.bash_profile
mv ~/.bash_non_interactive.d /tmp && ln -s ~/.bash/bash_non_interactive.d ~/.bash_non_interactive.d
