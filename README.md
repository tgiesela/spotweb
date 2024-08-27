# Docker Spotweb image
A collection of docker images running [Spotweb](https://github.com/spotweb/spotweb) based on [php 8.1.16/apache2/debian 11/](https://hub.docker.com/_/php/), a database of your own choice (Mariadb/PostgreSQL/Sqlite) and optionally a database admin container (phpMyAdmin/adminer/pgadmin4).

## Background
This setup is based on the work of [Jeroen Geusebroek](https://github.com/jgeusebroek/docker-spotweb).
The changes I made were required to run it on raspberry pi 4 (4GB) with Debian 11 (32-bit) because there were issues with the SSL-connection to the newserver.
Unfortunately the mysql/mariadb crashes with corrupted indexes on the RPI although it runs without problems on a 64-bit machine. So maybe the problems are caused by insufficient memory or the 32-bit version. 
That is why I added the option for PostgreSQL and Sqlite. These databases run without problems on Raspberry Pi 4 (32-bit).

For mysql/mariadb I added a custom.cnf as an example in which I changed the memory parameters and disabled bin-log.
For PostgreSQL I added a postgresql.conf as an example with changed memory parameters (source: https://pgtune.leopard.in.ua/). This one can replace /var/lib/postgresql/data/postgresql.conf
These two files are not automatically incorporated into the running docker images, so you will have to include them yourself.
Refer to the documentation of the official images of [Mariadb](https://hub.docker.com/_/mariadb) and [PostgreSQL](https://hub.docker.com/_/postgres).

## Requirements
This installation consists of a set of docker-compose files.
It contains the spotweb server, a database server and an admin server linked to the database.
You will need an account for a supported newserver.

## Usage
### Initial Installation
For each supported database engine there is a docker-compose.<dbengine>.yml file. Together with the docker-compose.yml file these files make up a configuration.
Edit the docker-compose.yml files to change passwords, volumes and ports as required for your installation. 
Before running docker-compose make sure you have set the variable in a file named 'vars'. See vars.example for the variables to set.
Select the database type you want to use and update the docker compose line in start.sh to use the specific yml file, e.g:

	docker compose -f docker-compose.postgresql.yml up --build -d

Then run the following command:

	./start.sh
	
If you selected postgreSQL as your database engine you will have to select the administration tool of your choice. You can choose between adminer (default docker container) and pgadmin4.
Pgadmin4 did not have a docker image available for the 32-bit RPI4 (armv71), so I had to build an image myself. 
For pgadmin4 a user ($PGADMINEMAIL) and a password (pgadmin4) is generated which you need to login. You can access pgadmin on http://yourhost:8080/pgadmin4.

### Configuration
When the containers have been started, empty the dbsettings.inc.php file. The file can be found on the config volume for the spotweb container.

	docker exec -it spotweb truncate -s 0 /config/dbsettings.inc.php
	
Then run the Spotweb installer using the web interface: 'http://yourhost:8085/install.php'. Note that on the RPI4 the first time you start it, it will take some time before the web-gui is available due to some initializations.
This will create the necessary database tables and users. The connection parameters to the database can simply be changed in the dbsettings.inc.php file. The newserver and user information can only be changed by running the install.php again.

### Use
You should now be able to reach the spotweb interface on port 8085.

Mysql: PhpMyAdmin will be available on http://yourhost:8080.
PostgreSQL: Admniner (http://yourhost:8080) or pgadmin4 (http://yourhost:8080/pgadmin) (You have to uncomment the one you want to use) will be available on port 8080. 

### Automatic retrieval of new spots
To enable automatic retrieval, you need to setup a cronjob on either the docker host or within the container.

#### Automatic retrieval of new spots on the docker host
To enable automatic retrieval, you need to setup a cronjob on the docker host.

	*/5 * * * * docker exec spotweb su -l www-data -s /usr/local/bin/php /var/www/spotweb/retrieve.php >/dev/null 2>&1

This example will retrieve new spots every 5 minutes.
#### Automatic retrieval of new spots from within the container
To enable automatic retrieval from within the container, use the `SPOTWEB_CRON_RETRIEVE` variable to specify the cron timing for retrieval. For example as additional parameter to the `docker run` command:

    -e 'SPOTWEB_CRON_RETRIEVE=*/5 * * * *'

### Environment variables
| Variable | Function |
| --- | --- |
| `TZ` | The timezone the server is running in. Defaults to `Europe/Amsterdam`. |
| `SPOTWEB_DB_TYPE` | Database type. Use `pdo_mysql` for MySQL, `pdo_pgsql` for PostgreSQL, `pdo_sqlite` for Sqlite. |
| `SPOTWEB_DB_HOST` | The database hostname / IP. |
| `SPOTWEB_DB_PORT` | The database port. Optional. |
| `SPOTWEB_DB_NAME` | The database used for spotweb. |
| `SPOTWEB_DB_USER` | The database server username. |
| `SPOTWEB_DB_PASS` | The database server password. |
| `SPOTWEB_CRON_RETRIEVE` | Cron schedule for article retrieval. E.g. `*/15 * * * *` for every fifteen minutes.|
| `PGADMINEMAIL` | The login account for pgadmin4. |
## License

MIT / BSD

## Author Information

[Jeroen Geusebroek](https://jeroengeusebroek.nl/)

[Tonny Gieselaar](mailto://tgiesela@gmail.com)
