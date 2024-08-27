#!/bin/bash

setup(){
    VENV=/pgadmin4
    source /etc/apache2/envvars
    source $VENV/bin/activate
    SITEPACKAGES=$(python -c 'import site; print(site.getsitepackages()[0])')

    sed -i "s/<mailserver>/${MAIL_SERVER}/g" /config_local.py
    sed -i "s/<mailserverport>/${MAIL_PORT}/g" /config_local.py
    sed -i "s/<mailusessl>/${MAIL_USE_SSL}/g" /config_local.py
    sed -i "s/<mailusetls>/${MAIL_USE_TLS}/g" /config_local.py
    sed -i "s/<mailuser>/${MAIL_USERNAME}/g" /config_local.py
    sed -i "s/<mailpassword>/${MAIL_PASSWORD}/g" /config_local.py

    cp /config_local.py ${SITEPACKAGES}/pgadmin4/

    # Create config for pgadmin
    cat << _EOF > /etc/apache2/conf-available/pgadmin4.conf
WSGIDaemonProcess pgadmin processes=1 threads=25 python-home=${VENV}
WSGIScriptAlias /pgadmin ${SITEPACKAGES}/pgadmin4/pgAdmin4.wsgi

<Directory ${SITEPACKAGES}/pgadmin4>
    WSGIProcessGroup pgadmin
    WSGIApplicationGroup %{GLOBAL}
    Require all granted
</Directory>
_EOF

	python3 ${SITEPACKAGES}/pgadmin4/setup.py setup-db << _EOF
${PGADMINEMAIL}
${PGADMINPASSWORD}
${PGADMINPASSWORD}
_EOF

    sed -i "s/Listen 80/Listen ${PGADMINPORT}/g" /etc/apache2/ports.conf
    chown -R www-data:www-data /config
    /usr/sbin/a2enmod wsgi 
    /usr/sbin/a2enconf pgadmin4 

    # Clean up apache pid (if there is one)
    rm -rf /run/apache2/apache2.pid

    unset rt
    /usr/sbin/a2enmod rewrite && rt=1
    /usr/sbin/a2enmod expires && rt=1
    /usr/sbin/a2enmod deflate && rt=1

    # Only restart if one of the enmod commands succeeded
    if [[ -n $rt ]]; then
        touch /.setupdone
    fi
}
start(){
	TZ=${TZ:-"Europe/Amsterdam"}
	source /etc/apache2/envvars
    	apache2 -D FOREGROUND
        tail -f /config_local.py
}

if [[ ! -f /.setupdone ]] ; then
    setup
fi
start
