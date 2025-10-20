# enforce a specific order to ensure PATH is setup properly
files=(
  path.sh
  node.sh
  homebrew.sh
  python.sh
  ruby.sh
  nvm.sh
)

for file in "${files[@]}"; do
  filepath=~/.init/shell/interactive/ordered/$file
	if [ ! -f $filepath ]; then
		echo "Warning: file $filepath does not exist"
	else
		source $filepath;
	fi
done
