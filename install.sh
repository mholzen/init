#!/bin/bash

# set -o xtrace

# TODO: make modular so that I can choose what component(s) to install

srcdir="$( cd "$( dirname "$0" )" && pwd )"
todir=$HOME

echo "Install from $srcdir to $todir"
# set -x

function remove {
  path="$1"

  if [[ ! -a $path ]]; then
    # file does not exist: nothing to remove
   return;
  fi

  cp -rp "$path" "${path}".bak && rm "$path" || echo "failed to remove $path"
}

function install {
  from="$1"
  to="$2"
  to="$todir/$to"

  if [[ -L "$to" && $(readlink "$to") = "$from" ]]; then
    echo "$to installed correctly"
    return
  fi

  remove $to && ln -s $from $to && echo "ln -s $from $to"
}

install "$srcdir" .bash
install $todir/.bash/bash_profile .bash_profile
install $todir/.bash/bash_non_interactive.d .bash_non_interactive.d

install $srcdir/inputrc .inputrc

install $srcdir/atom/init.coffee .atom/init.coffee
install $srcdir/atom/keymap.cson .atom/keymap.cson

install $srcdir/npm/npmrc .npmrc

touch ~/.hushlogin
