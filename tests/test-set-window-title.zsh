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
