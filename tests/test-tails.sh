#!/usr/bin/env bash
# Checks that tails labels each line with the distinguishing part of the file path.
set -u
tails=$(cd "$(dirname "$0")/.." && pwd)/bin/tails
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
failures=0

labels_for() {
  local expected=$1; shift
  for file; do mkdir -p "$(dirname "$file")"; : > "$file"; done
  "$tails" "$@" > "$work/output" 2>&1 &
  local pid=$!
  sleep 1
  for file; do echo "line" >> "$file"; done
  sleep 1
  kill "$pid"; wait "$pid" 2>/dev/null
  local actual
  actual=$(sort "$work/output" | tr '\n' ' ')
  if [ "$actual" != "$expected" ]; then
    echo "FAIL: tails $*: expected '$expected', got '$actual'"
    failures=$((failures + 1))
  fi
}

cd "$work"
labels_for "[a] line [ab] line " a/out.log ab/out.log
labels_for "[db] line [web] line " "$work/tmp/web.log" "$work/tmp/db.log"
labels_for "[out.log] line " single/out.log

sleep 1
if pgrep -f "tail -n 0 -F .*$work" > /dev/null; then
  echo "FAIL: tail processes still running after tails was killed"
  failures=$((failures + 1))
fi

if "$tails" > /dev/null 2>&1; then
  echo "FAIL: tails without files should fail"
  failures=$((failures + 1))
fi

[ "$failures" -eq 0 ] && echo "ok: tails"
exit "$failures"
