FROM debian:bullseye
LABEL Author="Tonny Gieselaar <tgiesela@gmail.com>"
# From https://www.pgadmin.org/download/pgadmin-4-python/
ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm" 

RUN apt update && apt -yq install \
	build-essential \
	zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
	libssl-dev \
	libreadline-dev \
	libffi-dev \
	libsqlite3-dev \
	wget curl \
	libbz2-dev \
	nano \
	locales \
        python3 \
        python3-pip \
        python3-venv \
        libpq-dev python-dev \
	libjpeg-dev \
	apache2 \
	apache2-utils \
	ssl-cert \
	libapache2-mod-wsgi-py3

RUN locale-gen --no-purge nl_NL.UTF-8 en_US.UTF-8
RUN python3 -m venv /pgadmin4 
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN . ${HOME}/.cargo/env && . /pgadmin4/bin/activate && pip install pgadmin4

    # Postgresql version15 not available on armv71 so we use the available version
RUN apt -qy install postgresql-client-13
    # Cleanup
RUN apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

EXPOSE 80

COPY config_local.py /config_local.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
VOLUME /config/
ENTRYPOINT ["/entrypoint.sh"]

