#!/bin/sh

dir="$( cd "$( dirname "$0" )" && pwd )"
test -d $dir || echo "cannot locate the source directory"

function uninstall() {
  local file=$1
  test ! -r $file || return;
  test -h $file && rm $file;
  test ! -r $file || ( echo "cannot uninstall $file"; exit 1 )
}
function install() {
  local file=$1
  ln -s $dir $file
}
uninstall ~/.use-bash
install ~/.use-bash

source $dir/files.sh || exit "cannot locate installed directory"

for file in ${files[*]}; do
        target=~/.$file
        if [ -h $target ]; then rm $target; fi
	if [ ! -d $target ]; then ln -sf $dir/$file $target; fi
done
