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

A detached HEAD has no current branch and therefore uses the repository name.
Outside a Git worktree, branch and repository modes use the directory name.

Calling `set-tab-title <text>` disables following and fixes the supplied title.
Calling `clear-tab-title` disables following and restores the existing automatic
repository-or-directory title.

## Design

Keep the behavior in `shell/functions/set-window-title`, where title selection
already lives. A shell variable records the active follow mode. The existing
title function selects the title for that mode and preserves today's default
behavior when no follow mode is active.

Register one zsh `precmd` hook. The hook does nothing unless a follow mode is
active, avoiding coupling title updates to `PS1` and avoiding separate hook
registration state for every command. Existing directory-change updates remain
in place.

## Errors

Git lookup failures are expected fallback conditions, not user errors. The
commands fall through to the next title source. Invalid internal follow-mode
values fail visibly with a contextual `Cannot set tab title` error.

## Verification

A zsh test creates temporary Git repositories and verifies branch, repository,
directory, detached-HEAD, fixed-title, and clear-title behavior. The existing
shell tests remain green. The README documents the new commands.
