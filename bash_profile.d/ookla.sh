DEV=~/develop/teamookla
alias cdo='cd $DEV'
alias n=netgauge
export VAGRANT_CWD="$DEV/vagrant/development"

export PROJECT_BASE=$DEV
export POCO_BASE=$PROJECT_BASE/poco

PATH=$PATH:$DEV/speedtest-as3-tests/bin:$DEV/speedtest-as3-core/bin

PATH=$DEV/speedtestnet/vendor/phpunit/phpunit/:$PATH
