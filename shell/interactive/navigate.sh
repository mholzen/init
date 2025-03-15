function cdm {
  local base_dir="$HOME/develop/mholzen"
  
  if [[ $# -eq 0 ]]; then
    # No arguments, just cd to the base directory
    cd "$base_dir"
  else
    # With arguments, cd to the specified subdirectory
    local target_dir="$base_dir/$@"
    if [[ -d "$target_dir" ]]; then
      cd "$target_dir"
    else
      echo "Error: Directory '$@' does not exist in $base_dir"
      return 1
    fi
  fi
}

alias pd=pushd
alias po=popd
