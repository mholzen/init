#!/bin/bash

cd $HOME

srcdir=.init/shell

if [ ! -d "$srcdir" ]; then
	echo "Directory $srcdir does not exist"
	exit 1
fi

set -o xtrace
ln -sf $srcdir/zshrc .zshrc
ln -sf $srcdir/inputrc .inputrc

# use zsh init script for bash
ln -sf .zshrc .bash_profile