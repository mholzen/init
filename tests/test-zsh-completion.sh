#!/bin/zsh

# Test script for ZSH completion

echo "Testing ZSH completion setup..."

# Check if ZSH is running
if [ -z "$ZSH_VERSION" ]; then
  echo "Error: This script must be run in ZSH"
  exit 1
fi

# Check if the completion system is initialized
if ! typeset -f compdef > /dev/null; then
  echo "Error: ZSH completion system is not initialized"
  echo "Try running: autoload -Uz compinit && compinit"
  exit 1
fi

# Check if _describe is available
if ! typeset -f _describe > /dev/null; then
  echo "Warning: _describe function is not available"
  echo "Try running: autoload -Uz _describe"
else
  echo "✓ _describe function is available"
fi

# Check if our completion function is available
if ! typeset -f _cdm > /dev/null; then
  echo "Error: _cdm function is not available"
  if [ -f "$HOME/.bash/functions/_cdm" ]; then
    echo "Try running: source $HOME/.bash/functions/_cdm"
  else
    echo "File not found: $HOME/.bash/functions/_cdm"
  fi
  exit 1
else
  echo "✓ _cdm function is available"
fi

# Check if the completion is registered for cdm
if compdef -d | grep -q "_cdm cdm"; then
  echo "✓ Completion is registered for cdm"
else
  echo "Warning: Completion is not registered for cdm"
  echo "Try running: compdef _cdm cdm"
fi

echo "Test complete." 