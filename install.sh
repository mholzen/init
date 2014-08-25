#!/bin/sh

# Symlinks dot files to files in the current working directory

dir="$( cd "$( dirname "$0" )" && pwd )"
source $dir/files.sh

rm ~/.use-bash || exit "cannot uninstall ~/.use-bash"
ln -sf $dir ~/.use-bash

for file in ${files[*]}; do
        target=~/.$file
        if [ -h $target ]; then rm $target; fi
	if [ ! -d $target ]; then ln -sf $dir/$file $target; fi
done
