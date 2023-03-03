FROM php:8.1.16-apache-bullseye
LABEL Author="Tonny Gieselaar <tgiesela@gmail.com>"

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm" \ 
    APTLIST="git-core cron wget jq locales"

RUN apt -y update && apt -qy install ${APTLIST} && \
    locale-gen --no-purge nl_NL.UTF-8 en_US.UTF-8 && \
    a2enmod headers 

RUN git clone --no-checkout -b master --depth 1 --single-branch https://github.com/spotweb/spotweb.git /var/www/spotweb && \
    cd /var/www/spotweb && \
    git config core.symlinks false && \
    git checkout && \
    rm -rf /var/www/spotweb/.git && \
    chmod -R 775 /var/www/spotweb && \
    chown -R www-data:www-data /var/www/spotweb

RUN apt -y install libffi-dev libmpc-dev libpq-dev libxslt1-dev libzip-dev && \
    # Cleanup
    apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /var/www/html && \
    rm -rf /tmp/*

RUN docker-php-ext-install \
    calendar exif ffi gettext gmp \
    mysqli pcntl pdo pdo_mysql pdo_pgsql pgsql \
    shmop sockets sysvmsg sysvsem sysvshm xsl zip

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
