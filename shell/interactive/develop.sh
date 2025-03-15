export GITUSER=mholzen
export DEVROOT=~/develop/$GITUSER
export DEVBIN=$DEVROOT/bin
export PATH=$DEVBIN:$PATH

cdm() {
  local base_dir="$DEVROOT"
  
  if [[ $# -eq 0 ]]; then
    cd "$DEVROOT"
  else
    local target_dir="$DEVROOT/$1"
    if [[ -d "$target_dir" ]]; then
      cd "$target_dir"
    else
      echo "Error: Directory '$1' does not exist in $DEVROOT"
      return 1
    fi
  fi
}

check_or_make_dir() {
  local dir=$1
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
  fi
}

install_binary() {
  local binary_name=$1
  check_or_make_dir $DEVBIN
  cp $DEVBIN/$binary_name $DEVBIN/
}

symlink_binary() {
  local binary_name=$1
  check_or_make_dir $DEVBIN
  ln -s $binary_name $DEVBIN/
}