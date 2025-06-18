#!/bin/zsh

if [ -n "$ZSH_VERSION" ]; then
  # Add a directory to the function path for autoload
  fpath=($HOME/.init/shell/functions $fpath)

  # Load the base completion system first
  autoload -Uz compinit
  compinit

  # Load required completion functions
  autoload -Uz _describe

  compdef _cdm cdm
  compdef _just just
fi