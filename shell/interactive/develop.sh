export GITUSER=mholzen
export DEVROOT=~/develop/$GITUSER

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
