FROM debian:12.7

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm" \ 
    APTLIST="cron wget curl ca-certificates jq locales nano sqlite3 dnsutils iproute2 net-tools procps iputils-ping" \
    UPDATE="apt update && apt -y upgrade" \
    CLEANUP="apt -y autoremove && apt -y clean && rm -rf /var/lib/apt/lists"

RUN eval ${UPDATE} && \
	apt -qy install --no-install-recommends ${APTLIST} && \
    locale-gen --no-purge nl_NL.UTF-8 en_US.UTF-8 && \
    eval ${CLEANUP}

RUN sed -i 's/^Components: main$/& contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources && \
    apt update && \
	apt install unrar 7zip && \
	eval ${CLEANUP}
RUN wget https://nzbget.net/download/nzbget-latest-bin-linux.run

EXPOSE 6789

COPY --chmod=755 init.sh /init.sh
VOLUME /config/
VOLUME /download/
ENTRYPOINT ["/init.sh"]
CMD ["app:start"]

