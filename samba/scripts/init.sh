#!/bin/bash

set -e
DAEMON=/usr/sbin/smbd
info () {
    echo "[INFO] $@"
}

appSetup() {
    info "setup"
}

appStart() {
    [ -f /.alreadysetup ] && info "Skipping setup..." || appSetup
    info "start"

    trap "appStop" SIGTERM
    trap "appStop" SIGINT
    set +e
    exec ${DAEMON} --interactive --no-process-group $

    info "Wait completed"
tail -f /init.sh
}
appStop() {
    info "TRAP HANDLER" active
    info "Stopping"
}

appHelp() {
        echo "Available options:"
        echo " app:start          - Starts nordvpn"
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
echo "Exiting now"
exit 0
