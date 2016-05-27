#!/bin/bash

srcdir="$( cd "$( dirname "$0" )" && pwd )"

trash ~/.bash; ln -s "$srcdir" ~/.bash
trash ~/.bash_profile; ln -s ~/.bash/bash_profile ~/.bash_profile
trash ~/.bash_non_interactive.d; ln -s ~/.bash/bash_non_interactive.d ~/.bash_non_interactive.d

trash ~/.atom/init.coffee
ln -s $srcdir/atom/init.coffee ~/.atom/init.coffee

trash ~/.npmrc
ln -s $srcdir/npm/npmrc ~/.npmrc
