#!/bin/sh

# Symlinks dot files to files in the current working directory

dir="$( cd "$( dirname "$0" )" && pwd )"
source $dir/files.sh

for file in ${files[*]}; do
	target=~/.$file
	if [ -h $target ]; then rm $target; fi
done
