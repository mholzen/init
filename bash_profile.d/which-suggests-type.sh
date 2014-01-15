function which() {
  echo "Might I suggest type?" 1>&2
  type "$@" 1>&2
  /usr/bin/which "$@"
}