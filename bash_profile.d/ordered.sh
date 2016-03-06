# enforce a specific order to ensure PATH is setup properly
files=(
  nvm.sh
  use-bash-binaries.sh
  use-bash-npm.sh
  node.sh
  ookla.sh
  python.sh
  macports.sh
)

for file in "${files[@]}"; do
  filepath=~/.use-bash/bash_profile.d/ordered/$file
	if [ -f $filepath ]; then
		source $filepath;
	fi
done


