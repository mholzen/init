# enforce a specific order to ensure PATH is setup properly
files=(
  path.sh
  nvm.sh
  npm.sh
  node.sh
  ookla.sh
  local.sh
  python.sh
  # disabling macport because of conflict with node (uninstalling macport requires updating it)
  # macports.sh
)

for file in "${files[@]}"; do
  filepath=~/.bash/bash_profile.d/ordered/$file
	if [ -f $filepath ]; then
		source $filepath;
	fi
done
