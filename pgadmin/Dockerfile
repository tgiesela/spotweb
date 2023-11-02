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

RUN mkdir /.cargo && \
	printf "[net]\nretry = 3 # network retries\ngit-fetch-with-cli = true # use the git executable for git operations\n" > /.cargo/config.toml

RUN eval ${UPDATE} && \
	apt -qy install \
		git \
	    build-essential \
		rustc \
		pip \
		libpq-dev \
		libffi-dev \
		libjpeg-dev \
		libssl-dev \
		zlib1g-dev \
		postgresql-client-13 && \
    eval ${CLEANUP}
RUN python3 -m venv /pgadmin4 && \
    . /pgadmin4/bin/activate && \
    pip install --upgrade pip setuptools wheel && \
    pip install pgadmin4 

EXPOSE 80

COPY config_local.py /config_local.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
VOLUME /config/
ENTRYPOINT ["/entrypoint.sh"]

