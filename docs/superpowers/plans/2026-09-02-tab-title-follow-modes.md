# Tab Title Follow Modes Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the zsh tab title follow the current Git branch by default and provide one-shot branch, branch-follow, repository-follow, and directory-follow commands.

**Architecture:** Keep title resolution and command state in the existing `set-window-title` function file. Replace the custom directory-change function with one idempotent zsh prompt hook, and initialize branch-follow only when the shell has no existing fixed title or follow mode.

**Tech Stack:** zsh 5.9, Git CLI, OSC 0 terminal title sequence, shell assertion test

---

## Chunk 1: Title behavior

### Task 1: Specify title selection and command state

**Files:**
- Create: `tests/test-set-window-title.zsh`
- Test: `shell/functions/set-window-title`

- [ ] **Step 1: Write the failing behavior test**

Create this runnable test:

```zsh
#!/bin/zsh

set -u

repository_root=${0:A:h:h}
test_root=$(mktemp -d)
original_path="$PATH"
output_file="$test_root/output"
error_file="$test_root/error"
trap 'rm -rf -- "$test_root"' EXIT

fail() {
    print -u2 -- "$1"
    exit 1
}

assert-equal() {
    local expected="$1"
    local actual="$2"
    [[ "$actual" == "$expected" ]] || fail "Expected ${(qqq)expected}, got ${(qqq)actual}"
}

assert-title() {
    local expected="$1"
    shift
    "$@" > "$output_file" || fail "Expected $* to succeed"
    assert-equal "$expected" "$(< "$output_file")"
}

assert-failure-containing() {
    local expected="$1"
    shift
    "$@" > "$output_file" 2> "$error_file" && fail "Expected $* to fail"
    local error="$(< "$error_file")"
    [[ "$error" == *"$expected"* ]] || fail "Expected error containing ${(qqq)expected}, got ${(qqq)error}"
}

source "$repository_root/shell/functions/set-window-title"

mkdir -p "$test_root/project/nested" "$test_root/outside"
git -C "$test_root/project" init --quiet
git -C "$test_root/project" checkout -b topic/title --quiet
git -C "$test_root/project" -c user.name=Test -c user.email=test@example.com \
    commit --allow-empty --message initial --quiet
cd "$test_root/project/nested"

assert-title $'\e]0;topic/title\a' set-tab-title-follow-branch
assert-equal branch "$ITERM_SESSION_TITLE_FOLLOW_MODE"
assert-equal unset "${ITERM_SESSION_TITLE-unset}"

assert-title $'\e]0;project\a' set-tab-title-follow-repo
assert-equal repo "$ITERM_SESSION_TITLE_FOLLOW_MODE"
assert-title $'\e]0;nested\a' set-tab-title-follow-dir
assert-equal dir "$ITERM_SESSION_TITLE_FOLLOW_MODE"
assert-title $'\e]0;topic/title\a' set-tab-title-follow-branch

set-tab-title fixed > /dev/null
assert-title $'\e]0;topic/title\a' set-tab-title-follow-branch
assert-equal unset "${ITERM_SESSION_TITLE-unset}"

git -C "$test_root/project" checkout --detach --quiet
assert-title $'\e]0;project\a' set-window-title

set-tab-title fixed > /dev/null
assert-title $'\e]0;project\a' set-tab-title-follow-repo
assert-equal repo "$ITERM_SESSION_TITLE_FOLLOW_MODE"

set-tab-title fixed > /dev/null
assert-title $'\e]0;nested\a' set-tab-title-follow-dir
assert-equal dir "$ITERM_SESSION_TITLE_FOLLOW_MODE"

set-tab-title fixed > /dev/null
assert-title $'\e]0;fixed\a' set-window-title
assert-equal unset "${ITERM_SESSION_TITLE_FOLLOW_MODE-unset}"

git -C "$test_root/project" checkout topic/title --quiet
set-tab-title-follow-dir > /dev/null
assert-title $'\e]0;topic/title\a' set-tab-title-branch
assert-equal topic/title "$ITERM_SESSION_TITLE"
assert-equal unset "${ITERM_SESSION_TITLE_FOLLOW_MODE-unset}"

set-tab-title fixed > /dev/null
assert-title $'\e]0;topic/title\a' set-tab-title-branch

set-tab-title fixed > /dev/null
assert-title $'\e]0;topic/title\a' clear-tab-title
assert-equal branch "$ITERM_SESSION_TITLE_FOLLOW_MODE"

cd "$test_root/outside"
unset ITERM_SESSION_TITLE
ITERM_SESSION_TITLE_FOLLOW_MODE=branch
assert-title $'\e]0;outside\a' set-window-title
ITERM_SESSION_TITLE_FOLLOW_MODE=repo
assert-title $'\e]0;outside\a' set-window-title

ITERM_SESSION_TITLE_FOLLOW_MODE=invalid
assert-failure-containing "Cannot set tab title for mode 'invalid' from '$PWD'" set-window-title

mkdir "$test_root/bin"
print '#!/bin/sh\necho broken-git >&2\nexit 2' > "$test_root/bin/git"
chmod +x "$test_root/bin/git"
PATH="$test_root/bin:$PATH"
ITERM_SESSION_TITLE_FOLLOW_MODE=repo
assert-failure-containing "Cannot set tab title for mode 'repo' from '$PWD': broken-git" set-window-title
PATH="$original_path"

print 'Tab title tests passed'
```

- [ ] **Step 2: Run the test to verify RED**

Run: `zsh tests/test-set-window-title.zsh`

Expected: FAIL because `set-tab-title-follow-branch` is not defined.

- [ ] **Step 3: Commit the failing test**

```bash
git add tests/test-set-window-title.zsh
git commit -m "test tab title follow modes"
```

### Task 2: Implement minimal title selection and commands

**Files:**
- Modify: `shell/functions/set-window-title`
- Test: `tests/test-set-window-title.zsh`

- [ ] **Step 1: Add one shared title resolver**

Add this resolver above `set-window-title`:

```zsh
get-tab-title() {
    local mode="${1-}"
    local git_root
    local git_status
    local title

    case "$mode" in
        dir)
            print -r -- "${PWD:t}"
            return
            ;;
        branch|repo)
            ;;
        *)
            print -u2 -- "Cannot set tab title for mode '$mode' from '$PWD': unsupported follow mode"
            return 1
            ;;
    esac

    git_root=$(LC_ALL=C git rev-parse --show-toplevel 2>&1)
    git_status=$?
    if (( git_status != 0 )); then
        if [[ "$git_root" == *"not a git repository"* ]]; then
            print -r -- "${PWD:t}"
            return
        fi
        print -u2 -- "Cannot set tab title for mode '$mode' from '$PWD': $git_root"
        return "$git_status"
    fi

    if [[ "$mode" == branch ]]; then
        title=$(LC_ALL=C git branch --show-current 2>&1)
        git_status=$?
        if (( git_status != 0 )); then
            print -u2 -- "Cannot set tab title for mode '$mode' from '$PWD': $title"
            return "$git_status"
        fi
        if [[ -n "$title" ]]; then
            print -r -- "$title"
            return
        fi
    fi

    print -r -- "${git_root:t}"
}
```

- [ ] **Step 2: Route existing output through the resolver**

```zsh
set-window-title() {
    local title

    if [[ -n "${ITERM_SESSION_TITLE-}" ]]; then
        title="$ITERM_SESSION_TITLE"
    else
        title=$(get-tab-title "${ITERM_SESSION_TITLE_FOLLOW_MODE:-repo}") || return $?
    fi

    print -n "\033]0;${title}\007"
}
```

- [ ] **Step 3: Add the four requested commands**

Implement the three follow commands:

```zsh
set-tab-title-follow-branch() {
    unset ITERM_SESSION_TITLE
    typeset -g ITERM_SESSION_TITLE_FOLLOW_MODE=branch
    set-window-title
}

set-tab-title-follow-repo() {
    unset ITERM_SESSION_TITLE
    typeset -g ITERM_SESSION_TITLE_FOLLOW_MODE=repo
    set-window-title
}

set-tab-title-follow-dir() {
    unset ITERM_SESSION_TITLE
    typeset -g ITERM_SESSION_TITLE_FOLLOW_MODE=dir
    set-window-title
}
```

Implement the one-shot command by resolving branch mode and passing that title
to the existing fixed-title command:

```zsh
set-tab-title-branch() {
    local title
    title=$(get-tab-title branch) || return
    set-tab-title "$title"
}
```

Replace the fixed and clear command bodies with:

```zsh
set-tab-title() {
    if [[ -n "${1-}" ]]; then
        unset ITERM_SESSION_TITLE_FOLLOW_MODE
        export ITERM_SESSION_TITLE="$1"
        set-window-title
        return
    fi

    clear-tab-title
}

clear-tab-title() {
    set-tab-title-follow-branch
}
```

- [ ] **Step 4: Run the focused test to verify GREEN**

Run: `zsh tests/test-set-window-title.zsh`

Expected: PASS with `Tab title tests passed`.

- [ ] **Step 5: Commit the implementation**

```bash
git add shell/functions/set-window-title tests/test-set-window-title.zsh
git commit -m "add tab title follow modes"
```

## Chunk 2: Prompt integration and documentation

### Task 3: Make branch-follow the idempotent startup default

**Files:**
- Create: `justfile`
- Modify: `shell/interactive/zsh_hooks.sh`
- Modify: `tests/test-set-window-title.zsh`

- [ ] **Step 1: Extend the test for hook lifecycle**

Append these lifecycle checks after restoring `PATH` and before the final success
message:

```zsh
PATH="$original_path"

run-precmd-hooks() {
    local hook
    for hook in "${precmd_functions[@]}"; do
        "$hook"
    done
}

cd "$test_root/project"
git checkout topic/title --quiet
unset ITERM_SESSION_TITLE ITERM_SESSION_TITLE_FOLLOW_MODE
precmd_functions=()

source "$repository_root/shell/interactive/zsh_hooks.sh" > "$output_file"
assert-equal $'\e]0;topic/title\a' "$(< "$output_file")"
assert-equal branch "$ITERM_SESSION_TITLE_FOLLOW_MODE"

source "$repository_root/shell/interactive/zsh_hooks.sh" > "$output_file"
assert-equal '' "$(< "$output_file")"
title_hooks=("${(@M)precmd_functions:#update-followed-tab-title}")
assert-equal 1 "${#title_hooks}"

git checkout -b next/title --quiet
assert-title $'\e]0;next/title\a' run-precmd-hooks

set-tab-title fixed > /dev/null
source "$repository_root/shell/interactive/zsh_hooks.sh" > "$output_file"
assert-equal fixed "$ITERM_SESSION_TITLE"
assert-equal unset "${ITERM_SESSION_TITLE_FOLLOW_MODE-unset}"
assert-title '' run-precmd-hooks

set-tab-title-follow-repo > /dev/null
source "$repository_root/shell/interactive/zsh_hooks.sh" > "$output_file"
assert-equal repo "$ITERM_SESSION_TITLE_FOLLOW_MODE"

set-tab-title-follow-dir > /dev/null
source "$repository_root/shell/interactive/zsh_hooks.sh" > "$output_file"
assert-equal dir "$ITERM_SESSION_TITLE_FOLLOW_MODE"

clear-tab-title > /dev/null
assert-equal branch "$ITERM_SESSION_TITLE_FOLLOW_MODE"
```

- [ ] **Step 2: Run the test to verify RED**

Run: `zsh tests/test-set-window-title.zsh`

Expected: FAIL because no `precmd` hook establishes branch-follow.

- [ ] **Step 3: Replace the directory hook with the prompt hook**

Use zsh’s native hook helper, a fixed-title guard, and nounset-safe startup
initialization:

```zsh
if [[ -n "$ZSH_VERSION" ]]; then
    update-followed-tab-title() {
        [[ -n "${ITERM_SESSION_TITLE_FOLLOW_MODE-}" ]] || return 0
        set-window-title
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd update-followed-tab-title

    if [[ -z "${ITERM_SESSION_TITLE_FOLLOW_MODE+x}" && -z "${ITERM_SESSION_TITLE-}" ]]; then
        set-tab-title-follow-branch
    fi
fi
```

Remove the custom `chpwd` function. The guarded prompt hook emits nothing while
a fixed title is active.

- [ ] **Step 4: Add the repository test command**

Create the minimal `justfile`:

```just
test:
    zsh -n shell/functions/set-window-title shell/interactive/zsh_hooks.sh tests/test-set-window-title.zsh
    zsh tests/test-set-window-title.zsh
```

- [ ] **Step 5: Run the focused and existing tests**

Run: `just test`

Expected: PASS with `Tab title tests passed`.

Run: `zsh -c 'autoload -Uz compinit && compinit && source shell/functions/_cdm && source tests/test-zsh-completion.sh'`

Expected: exit 0; output ends with `Test complete.` The existing warning that
`cdm` completion is not registered is unchanged and outside this feature.

- [ ] **Step 6: Commit prompt integration**

```bash
git add justfile shell/interactive/zsh_hooks.sh tests/test-set-window-title.zsh
git commit -m "follow Git branch in tab title by default"
```

### Task 4: Document the commands

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Add the Tab Titles section**

Append:

```markdown
## Tab titles

Interactive zsh sessions follow the current Git branch by default, falling back
to the repository name and then the current directory.

- `set-tab-title-branch` sets the title once from the branch, repository, then directory.
- `set-tab-title-follow-branch` follows the branch, repository, then directory.
- `set-tab-title-follow-repo` follows the repository, then directory.
- `set-tab-title-follow-dir` follows the current directory.
- `set-tab-title <text>` fixes a custom title.
- `clear-tab-title` restores default branch following.
```

- [ ] **Step 2: Verify the final diff and tests**

Run: `git diff --check`

Expected: exit 0 with no output.

Run: `just test`

Expected: PASS with `Tab title tests passed`.

- [ ] **Step 3: Commit documentation**

```bash
git add README.md
git commit -m "document tab title commands"
```
