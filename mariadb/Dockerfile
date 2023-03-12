FROM ubuntu:latest

RUN apt -qy update && apt -qy upgrade
RUN apt -qy install mariadb-server mariadb-client nano

VOLUME [ "/config" ]

COPY init.sh /init.sh
RUN chmod +x /init.sh
COPY custom.cnf /
ENTRYPOINT ["/init.sh"]
CMD ["start"]
