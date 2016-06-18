#!/bin/bash

# TODO: make modular so that I can choose what component(s) to install

srcdir="$( cd "$( dirname "$0" )" && pwd )"
todir=$HOME
savedir=/tmp

function remove {
  path="$@"
  if [ ! -r $todir/$path ]; then return; fi
  if [ -r $savedir/$path ]; then rm $savedir/$path; fi
  mv $todir/$path $savedir/$path
}

function install {
  from="$1"
  to="$2"

  nothing_to_do=[ $(readlink "$from") -ef "$to" ]
  if $nothing_to_do; then return; fi

  remove $to && ln -s $from $todir/$to && echo "ln -s $from $todir/$to"
}

install "$srcdir" .bash
install $todir/.bash/bash_profile .bash_profile
install $todir/.bash/bash_non_interactive.d .bash_non_interactive.d

install $srcdir/atom/init.coffee .atom/init.coffee

install $srcdir/npm/npmrc .npmrc

touch ~/.hushlogin
