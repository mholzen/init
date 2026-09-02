# Account Initialization

Personalizations and customizations for shells and applications.

## Tab titles

Interactive zsh sessions follow the current Git branch by default, falling back
to the repository name and then the current directory.

- `set-tab-title-branch` sets the title once from the branch, repository, then directory.
- `set-tab-title-follow-branch` follows the branch, repository, then directory.
- `set-tab-title-follow-repo` follows the repository, then directory.
- `set-tab-title-follow-dir` follows the current directory.
- `set-tab-title <text>` fixes a custom title.
- `clear-tab-title` restores default branch following.
