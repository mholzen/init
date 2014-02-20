#!/bin/sh

# Symlinks dot files to files in the current working directory

src=`pwd`
ln -sf $src/bash_profile.sh ~/.bash_profile
ln -sf $src/bash_profile.d ~/.bash_profile.d
ln -sf $src/bash_non_interactive.sh ~/.bash_non_interactive
ln -sf $src/bash_non_interactive.d ~/.bash_non_interactive.d
ln -sf $src/inputrc ~/.inputrc

