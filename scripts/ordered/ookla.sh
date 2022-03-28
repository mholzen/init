DEV=~/develop/teamookla
alias n=netgauge
export VAGRANT_CWD="$DEV/vagrant/development"

export PROJECT_BASE=$DEV
export POCO_BASE=$PROJECT_BASE/poco

# Android development
if [ -r ~/Library/Android/sdk/platform-tools/ ]; then
  PATH="$PATH:$HOME/Library/Android/sdk/platform-tools/"
fi
#export ANDROID_HOME=${HOME}/develop/speedtestnet-android/toolchain/sdk
#export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/build-tools/android-4.2.2:${HOME}/develop/speedtestnet-android/speedtest"

# Speedtestnet
PATH=$PATH:$DEV/speedtestnet/vendor/phpunit/phpunit

PATH=$PATH:$DEV/jira/

# Embedded
PATH=$PATH:$DEV/native-artifacts/speedtest-embedded/latest