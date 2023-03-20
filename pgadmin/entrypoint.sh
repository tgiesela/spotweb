#!/bin/bash

setup(){
source /etc/apache2/envvars
/usr/pgadmin4/bin/setup-web.sh --yes << _EOF
${PGADMINEMAIL}
pgadmin4
pgadmin4
_EOF

/usr/sbin/a2enmod wsgi #1> /dev/null
/usr/sbin/a2enconf pgadmin4 #1> /dev/null

# Clean up apache pid (if there is one)
rm -rf /run/apache2/apache2.pid

# Enabling PHP mod rewrite, expires and deflate (they may be on already by default)
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
}

if [[ ! -f /.setupdone ]] ; then
    setup
fi
start
