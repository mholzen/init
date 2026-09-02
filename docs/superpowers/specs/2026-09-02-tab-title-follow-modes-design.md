# Tab Title Follow Modes

## Goal

Add one command that sets the tab title from the current Git branch and three
commands that keep the title synchronized at every zsh prompt.

## Commands

- `set-tab-title-branch` sets the title once using branch, repository, then
  directory as fallbacks.
- `set-tab-title-follow-branch` follows branch, repository, then directory.
- `set-tab-title-follow-repo` follows repository, then directory.
- `set-tab-title-follow-dir` follows the current directory.

The one-shot branch command disables any active follow mode and replaces any
fixed title before selecting its title.

A detached HEAD has no current branch and therefore uses the repository name.
Outside a Git worktree, branch and repository modes use the directory name.
The repository name is the basename of the top-level directory reported by
Git. This applies consistently in repository subdirectories, linked worktrees,
and submodules.

Each follow command clears any fixed title, records its shell-local mode, and
updates the title immediately. Subsequent prompts recompute it. Calling one
follow command replaces any previously active follow mode.

Calling `set-tab-title <text>` disables following and fixes the supplied title.
Calling `clear-tab-title` clears the fixed title and restores the default branch
follow mode.

## Design

Keep title selection in `shell/functions/set-window-title`, where it already
lives. A shell-local variable shared by the command functions and hook records
the active follow mode. The existing title function selects the title for that
mode and continues emitting the existing OSC 0 terminal-title sequence.

In `shell/interactive/zsh_hooks.sh`, register one zsh `precmd` hook and invoke
`set-tab-title-follow-branch` only when neither a fixed title nor a follow mode
already exists. This establishes the startup default without clobbering shell
state when configuration is sourced again. The hook does nothing while a fixed
title is active. This avoids coupling title updates to `PS1` and avoids separate
hook registration state for every command. Hook registration is idempotent when
the shell configuration is sourced repeatedly. Remove the existing custom
`chpwd` handler because the prompt hook covers both directory and branch changes.

## Errors

“Not a Git repository” and detached HEAD are expected fallback conditions. An
unexpected Git failure or invalid internal follow-mode value fails visibly with
a contextual `Cannot set tab title` error instead of silently changing the
meaning of the title.

## Verification

A zsh test creates temporary Git repositories and verifies branch, repository,
directory, detached-HEAD, fixed-title, and clear-title behavior. It also verifies
immediate follow-mode activation, prompt-time refresh, switching between modes,
the default branch-follow startup, fixed-title suspension, `clear-tab-title`
restoration, the one-shot command after fixed and followed titles, idempotent
hook registration, preservation of fixed and non-default modes when shell
configuration is sourced again, and invalid-mode failure. The existing shell
tests remain green. The README documents the new commands.
