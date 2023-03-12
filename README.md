# Docker Spotweb image

An image running [php/apache/debian/8.1.16](https://hub.docker.com/_/php/) Linux and [Spotweb](https://github.com/spotweb/spotweb).
This setup is based on the work of [Jeroen Geusebroek](https://github.com/jgeusebroek/docker-spotweb).
The changes I made were required to run it on raspberry pi with Debian 11.

## Requirements

This installation consists of a docker-compose file (Thanks to [Daniel Jongepier](https://github.com/djongepier)). 
It contains the spotweb server, a MariaDB server and a phpMyAdmin server linked to the mariaDB.

## Usage

### Initial Installation

Edit the docker-compose.yml file to change passwords, volumes and ports as required for your installation. Default the spotweb application uses port 8085 and the phpMyAdmin uses port 8080.
Then run the following command:

	docker-compose up --build -d
	
When the containers have been started, make the dbsettings.php.inc file empty. It will reside on the config volume for the spotweb container.
Then run the Spotweb installer using the web interface: 'http://yourhost:8085/install.php'.
This will create the necessary database tables and users.

The database port is also optional. If omitted it will use the standard port for MySQL / PostgreSQL.

You should now be able to reach the spotweb interface on port 8085.
PhpMyAdmin will be available on port 8080.

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
