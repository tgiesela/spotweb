#!/bin/bash
customconfig=/config/custom.cnf
basedir=/usr
datadir=/config/databases
plugindir=/usr/lib/mysql/plugin
user=mysql
pidfile=/var/run/mysqld/mysqld.pid
socket=/var/run/mysqld/mysqld.sock
safepid=
setup(){
	mkdir -p ${datadir}
	mkdir -p /config/log/mysql
        chown -R mysql ${datadir}
        chown -R mysql /config/log

	if [ ! -f /config/custom.cnf ] ; then
		cp /custom.cnf /config.custom.cnf
	fi

        mysql_install_db --user=${user} --ldata=${datadir}

        start NOWAIT
	mysql -u root --password=${MYSQL_ROOT_PASSWORD} << _EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
_EOF
#	stop
	fg
	touch /.setupdone
}
stop() {
	kill ${safepid}
        kill $(cat ${pidfile})
	echo "mariadbd and mariadbd-safe stopped"
        rm ${pidfile}
}
start(){
	/usr/bin/mariadbd-safe --defaults-extra-file=${customconfig} \
			       --basedir=${basedir} \
			       --datadir=${datadir} \
			       --plugin-dir=${plugindir} \
			       --user=${user} \
			       --skip-log-error \
			       --skip-syslog \
			       --pid-file=${pidfile} \
			       --socket=${socket} &
	safepid=$!
	echo "[INFO]: Waiting for mariadb to finish startup"
	while [ -z "$(ss -an|grep 3306)" ]; do sleep 1 && echo "Waiting for mariadb"; done
	echo "[INFO]: Assume startup finished"

}
shutdown(){
	mariadb-admin -u root --password=${MYSQL_ROOT_PASSWORD} shutdown
}

set -me
case "$1" in
        start)
		if [ ! -f /.setupdone ]; then
			setup
		else
			start
		fi 
	#	The following line will keep the container running in case startup fails 
        	echo "Now waiting for events in: /config/databases/$(hostname).err"
		tail -f /config/databases/$(hostname).err
                ;;
        setup)
                setup
                ;;
        shutdown)
                shutdown
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
