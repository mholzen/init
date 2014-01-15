function cdr() {
  root=`findup .git | xargs dirname`
  if [ ! -z "$root" ]; then
    cd $root
  fi
}