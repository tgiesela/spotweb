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

RUN eval ${UPDATE} && \
	apt -qy install --no-install-recommends samba samba-client openssl && \
   eval ${CLEANUP}

COPY --chmod=255 scripts/init.sh /init.sh
COPY --chmod=255 scripts/addsambauser.sh /addsambauser.sh
COPY smb.conf /config/smb.conf
VOLUME [ "/config" ]

EXPOSE 137 138 139 445

ENTRYPOINT ["/init.sh"]
CMD ["app:start"]
