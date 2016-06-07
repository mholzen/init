# enforce a specific order to ensure PATH is setup properly
files=(
  nvm.sh
  bash-binaries.sh
  npm.sh
  node.sh
  ookla.sh
  python.sh
  macports.sh
)

for file in "${files[@]}"; do
  filepath=~/.bash/bash_profile.d/ordered/$file
	if [ -f $filepath ]; then
		source $filepath;
	fi
done


