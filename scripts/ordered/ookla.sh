DEV=~/develop/teamookla
alias n=netgauge
export VAGRANT_CWD="$DEV/vagrant/development"

export PROJECT_BASE=$DEV
export POCO_BASE=$PROJECT_BASE/poco

PATH=$PATH:$DEV/speedtest-as3-tests/bin:$DEV/speedtest-as3-core/bin

# Android development
#export ANDROID_HOME=${HOME}/develop/speedtestnet-android/toolchain/sdk
#export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/build-tools/android-4.2.2:${HOME}/develop/speedtestnet-android/speedtest"

export PATH="$PATH:${HOME}/develop/teamookla/android-sdk-macosx/platform-tools"

# Speedtestnet
PATH=$PATH:$DEV/speedtestnet/vendor/phpunit/phpunit

PATH=$PATH:$DEV/jira/
