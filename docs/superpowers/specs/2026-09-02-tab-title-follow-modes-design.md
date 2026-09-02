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
The repository name is the basename of the top-level directory reported by
Git. This applies consistently in repository subdirectories, linked worktrees,
and submodules.

Each follow command clears any fixed title, records its shell-local mode, and
updates the title immediately. Subsequent prompts recompute it. Calling one
follow command replaces any previously active follow mode.

Calling `set-tab-title <text>` disables following and fixes the supplied title.
Calling `clear-tab-title` disables following and restores the existing automatic
repository-or-directory title.

## Design

Keep the behavior in `shell/functions/set-window-title`, where title selection
already lives. A shell-local variable shared by the command functions and hook
records the active follow mode. The existing title function selects the title
for that mode and preserves today's default behavior when no follow mode is
active.

Register one zsh `precmd` hook. The hook does nothing unless a follow mode is
active, avoiding coupling title updates to `PS1` and avoiding separate hook
registration state for every command. Hook registration is idempotent when the
shell configuration is sourced repeatedly. Existing directory-change updates
remain in place.

## Errors

“Not a Git repository” and detached HEAD are expected fallback conditions. An
unexpected Git failure or invalid internal follow-mode value fails visibly with
a contextual `Cannot set tab title` error instead of silently changing the
meaning of the title.

## Verification

A zsh test creates temporary Git repositories and verifies branch, repository,
directory, detached-HEAD, fixed-title, and clear-title behavior. It also verifies
immediate follow-mode activation, prompt-time refresh, switching between modes,
idempotent hook registration, and invalid-mode failure. The existing shell tests
remain green. The README documents the new commands.
