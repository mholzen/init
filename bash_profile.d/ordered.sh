# enforce a specific order to ensure PATH is setup properly
files=(
  bash-binaries.sh
  nvm.sh
  npm.sh
  node.sh
  ookla.sh
  local.sh
  python.sh
  macports.sh
)

for file in "${files[@]}"; do
  filepath=~/.bash/bash_profile.d/ordered/$file
	if [ -f $filepath ]; then
		source $filepath;
	fi
done


