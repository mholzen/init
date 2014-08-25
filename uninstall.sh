#!/bin/sh

dir="$( cd "$( dirname "$0" )" && pwd )"
source $dir/files.sh

rm ~/.use-bash || exit "cannot uninstall ~/.use-bash"

for file in ${files[*]}; do
	target=~/.$file
	if [ -h $target ]; then rm $target; fi
done
