#!/bin/bash

set -e

info () {
    echo "[INFO] $@"
}

appSetup () {
    info "setup"
	sh nzbget-latest-bin-linux.run
    touch /.alreadysetup
}
appStop () {
    info "Signal $1 caught"
    /nzbget/nzbget -Q
	info "nzbget stopped"
}
appStart () {
    [ -f /.alreadysetup ] && info "Skipping setup..." || appSetup
    info "start"
    trap "appStop SIGINT" SIGINT
    trap "appStop SIGTERM" SIGTERM
    exec /nzbget/nzbget --option OutputMode=log --server --configfile /config/nzbget.conf &
    wait $!
    info "Process stopped"
}

appHelp () {
	echo "Available options:"
	echo " app:start          - Starts all services needed for mail server"
	echo " app:setup          - First time setup."
	echo " app:help           - Displays the help"
	echo " [command]          - Execute the specified linux command eg. /bin/bash."
}

case "$1" in
	app:start)
		appStart
		;;
	app:setup)
		appSetup
		;;
	app:help)
		appHelp
		;;
	*)
		if [ -x $1 ]; then
			$1
		else
			prog=$(which $1)
			if [ -n "${prog}" ] ; then
				shift 1
				$prog $@
			else
				appHelp
			fi
		fi
		;;
esac

exit 0
