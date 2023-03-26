FROM debian:bullseye
LABEL Author="Tonny Gieselaar <tgiesela@gmail.com>"
# From https://www.pgadmin.org/download/pgadmin-4-python/
ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm" \
    UPDATE="apt update && apt -y upgrade" \
    CLEANUP="apt -y autoremove && apt -y clean && rm -rf /var/lib/apt/lists"

RUN eval ${UPDATE} && \
	apt -qy install --no-install-recommends \
		wget \
		curl \
		nano \
		locales \
		python3 \
		python3-venv \
		apache2 apache2-utils \
		libapache2-mod-wsgi-py3 && \
        locale-gen --no-purge nl_NL.UTF-8 en_US.UTF-8 && \
    eval ${CLEANUP}

RUN eval ${UPDATE} && \
	apt -yq install --no-install-recommends \
		build-essential \
		zlib1g-dev \
	        libncurses5-dev \
		libgdbm-dev \
		libnss3-dev \
		libssl-dev \
		libreadline-dev \
		libffi-dev \
		libsqlite3-dev \
		libbz2-dev \
	        python3-pip \
	        libpq-dev python-dev \
		libjpeg-dev \
		ssl-cert && \
	python3 -m venv /pgadmin4 && \
	curl https://sh.rustup.rs -sSf | bash -s -- -y && \
        . ${HOME}/.cargo/env && \
	. /pgadmin4/bin/activate && \
	pip install pgadmin4 && \
        apt -yq remove --purge \
		build-essential \
		zlib1g-dev \
	        libncurses5-dev \
	        libgdbm-dev \
	        libnss3-dev \
		libssl-dev \
		libreadline-dev \
		libffi-dev \
		libsqlite3-dev \
		libbz2-dev \
	        python3-pip \
	        libpq-dev python-dev \
		libjpeg-dev \
		ssl-cert && \
	rustup self uninstall -y && \
    eval ${CLEANUP}

    # Postgresql version15 not available on armv71 so we use the available version
RUN eval ${UPDATE} && \
	apt -qy install --no-install-recommends postgresql-client-13 && \
    eval ${CLEANUP}

EXPOSE 80

COPY config_local.py /config_local.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
VOLUME /config/
ENTRYPOINT ["/entrypoint.sh"]

