function cdm {
  cd ~/develop/mholzen/$@
}

function cdo {
  cd ~/develop/teamookla/$@
}

function cd-new {
  if [[ -z "$@" ]]; then
    arg=~
  else
    arg="$@"
  fi
  pushd $arg
}

alias pd=pushd
alias po=popd
