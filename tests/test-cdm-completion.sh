#!/bin/zsh

# Test script for cdm completion

# Source the cdm function
source "$HOME/.bash/functions/cdm"

# Add the functions directory to fpath
fpath=("$HOME/.bash/functions" $fpath)

# Load the completion system
autoload -Uz compinit
compinit

# Print available completions for cdm
echo "Available completions for cdm:"
_cdm 