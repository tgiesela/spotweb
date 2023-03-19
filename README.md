# Docker Spotweb image

An image running [php/apache/debian/8.1.16](https://hub.docker.com/_/php/) Linux and [Spotweb](https://github.com/spotweb/spotweb).
This setup is based on the work of [Jeroen Geusebroek](https://github.com/jgeusebroek/docker-spotweb).
The changes I made were required to run it on raspberry pi 4 (4GB) with Debian 11 (32-bit) because there were issues with the SSL-connection to the newserver.
Unfortunately the mariadb crashes with corrupted indexes. It runs without problems in a 64-bit virtual machine. So maybe the problems are caused by insufficient memory or the 32-bit version. 
I added my custom.cnf for mariadb as an example in which I changed the memory parameters and disabled bin-log.
PostgreSQL and Sqlite run without problems on Raspberry Pi 4 (32-bit).

## Requirements

This installation consists of a set of docker-compose files.
It contains the spotweb server, a database server and an admin server linked to the database.

## Usage

### Initial Installation

For each database type you want to use there is a docker-compose.<dbtype>.tml file. Together with the docker-compose.yml file these files make up a configuration.
Edit the docker-compose.yml files to change passwords, volumes and ports as required for your installation. 
Select the database type you want to use and create a softlink to the specific yml file, e.g:

	ls -s docker-compose.postgresql.yml docker-compose.override.yml

Then run the following command:

	docker-compose up --build -d
	
If you do not create a softlink, you can start it with the following command:

	docker-compose -f docker-compose.yml -f docker-compose.postgresql.yml up --build -d

When the containers have been started, make the dbsettings.php.inc file empty. The file can be found on the config volume for the spotweb container.

	docker exec -it spotweb truncate -s 0 /config/dbsettings.inc.php
	
Then run the Spotweb installer using the web interface: 'http://yourhost:8085/install.php'.
This will create the necessary database tables and users.

You should now be able to reach the spotweb interface on port 8085.
Mysql: PhpMyAdmin will be available on port 8080.
PostgreSQL: Admniner or pgadmin4 (You have to uncomment the one you want to use) will be available on port 8080. 

To perform an orderly shutdown of the mariadb container, first execute the command:

	docker exec -it spotwebdb /init.sh shutdown

### Automatic retrieval of new spots
To enable automatic retrieval, you need to setup a cronjob on either the docker host or within the container.
#### Automatic retrieval of new spots on the docker host
To enable automatic retrieval, you need to setup a cronjob on the docker host.

	*/5 * * * * docker exec spotweb su -l www-data -s /usr/local/bin/php /var/www/spotweb/retrieve.php >/dev/null 2>&1

This example will retrieve new spots every 5 minutes.
#### Automatic retrieval of new spots from within the container
To enable automatic retrieval from within the container, use the `SPOTWEB_CRON_RETRIEVE` variable to specify the cron timing for retrieval. For example as additional parameter to the `docker run` command:

    -e 'SPOTWEB_CRON_RETRIEVE=*/5 * * * *'

### Updates

The container will try to auto-update the database when a newer version is released.

Note: the environment variables in docker-compose.yml override the settings you entered while executing install.php.

### Environment variables
| Variable | Function |
| --- | --- |
| `TZ` | The timezone the server is running in. Defaults to `Europe/Amsterdam`. |
| `SPOTWEB_DB_TYPE` | Database type. Use `pdo_mysql` for MySQL. |
| `SPOTWEB_DB_HOST` | The database hostname / IP. |
| `SPOTWEB_DB_PORT` | The database port. Optional. |
| `SPOTWEB_DB_NAME` | The database used for spotweb. |
| `SPOTWEB_DB_USER` | The database server username. |
| `SPOTWEB_DB_PASS` | The database server password. |
| `SPOTWEB_CRON_RETRIEVE` | Cron schedule for article retrieval. E.g. `*/15 * * * *` for every fifteen minutes.|
| `SPOTWEB_CRON_CACHE_CHECK` | Cron schedule for article cache sanity check. E.g. `10 */1 * * *` for 10 minutes after every hour. |

## License

MIT / BSD

## Author Information

[Jeroen Geusebroek](https://jeroengeusebroek.nl/)
[Tonny Gieselaar](https://gieselaar.ddns.net)
