FROM php:8.1.16-apache-bullseye
LABEL Author="Tonny Gieselaar <tgiesela@gmail.com>"

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm" \ 
    APTLIST="cron wget jq locales nano sqlite3 dnsutils iproute2 net-tools" \
    UPDATE="apt update && apt -y upgrade" \
    CLEANUP="apt -y autoremove && apt -y clean && rm -rf /var/lib/apt/lists"

RUN eval ${UPDATE} && \
	apt -qy install --no-install-recommends ${APTLIST} && \
    locale-gen --no-purge nl_NL.UTF-8 en_US.UTF-8 && \
    a2enmod headers && \
    eval ${CLEANUP}

RUN eval ${UPDATE} && \
	apt -qy install --no-install-recommends git-core && \
	git clone --no-checkout -b master --depth 1 --single-branch https://github.com/spotweb/spotweb.git /var/www/spotweb && \
    cd /var/www/spotweb && \
    git config core.symlinks false && \
    git checkout && \
    rm -rf /var/www/spotweb/.git && \
    chmod -R 775 /var/www/spotweb && \
    chown -R www-data:www-data /var/www/spotweb && \
	apt -y remove --purge git-core && \
    rm -r /var/www/html && \
   eval ${CLEANUP}

RUN eval ${UPDATE} && \
	apt -qy install --no-install-recommends libffi-dev libfreetype6-dev libjpeg-dev libmpc-dev libpng-dev libpq-dev libxslt1-dev libzip-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install \
	calendar \
	exif \
	ffi \
	gettext \
	gd \
	gmp \
        mysqli \
	pcntl \
	pdo \
	pdo_mysql \
	pdo_pgsql \
	pgsql \
	shmop \
	sockets \
	sysvmsg \
	sysvsem \
	sysvshm \
	xsl \
	zip  && \
    rm -rf /tmp/* && \
    apt -y remove --purge libffi-dev libfreetype6-dev libjpeg-dev libmpc-dev libpng-dev libpq-dev libxslt1-dev libzip-dev && \
    apt -qy install --no-install-recommends libffi7 libfreetype6 libjpeg62-turbo libmpc3 libpng16-16 libpq5 libxslt1.1 libzip4 && \
    eval ${CLEANUP}

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

COPY files/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Add caching and compression config to .htaccess
COPY files/001-htaccess.conf /
RUN cat /001-htaccess.conf >> /var/www/spotweb/.htaccess
RUN rm /001-htaccess.conf

VOLUME [ "/config" ]

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
