#!/bin/zsh

# ZSH completions setup
# This file sets up ZSH completions for custom commands

# Only run this in ZSH
if [ -n "$ZSH_VERSION" ]; then
  # Add functions directory to fpath for completions
  fpath=($HOME/.bash/functions $fpath)
  
  # Load the base completion system first
  autoload -Uz compinit
  compinit
  
  # Load required completion functions
  autoload -Uz _describe
  
  # Now load our custom completion functions
  if [[ -f $HOME/.bash/functions/_cdm ]]; then
    # Instead of autoloading, source the file directly to ensure it's properly loaded
    source $HOME/.bash/functions/_cdm
    compdef _cdm cdm
  fi
fi 