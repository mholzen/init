function script_dir() {
  echo $( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
}
