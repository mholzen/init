#!/bin/sh

dir="$( cd "$( dirname "$0" )" && pwd )"
source $dir/files.sh

rm ~/.bash || exit "cannot uninstall ~/.bash"

for file in ${files[*]}; do
	target=~/.$file
	if [ -h $target ]; then rm $target; fi
done
