FROM debian:bullseye
LABEL Author="Tonny Gieselaar <tgiesela@gmail.com>"

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm" 

RUN apt -y update && apt -qy install locales nano gnupg curl lsb-release && \
    curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | apt-key add && \
    sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
RUN apt -y update && apt -qy install pgadmin4 && \
    locale-gen --no-purge nl_NL.UTF-8 en_US.UTF-8 && \
    a2enmod headers 

    # Cleanup
RUN apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /var/www/html && \
    rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME [ "/config" ]

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["setup"]
