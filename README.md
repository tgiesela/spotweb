# Docker Spotweb image

An image running [php/apache/debian/8.1.16](https://hub.docker.com/_/php/) Linux and [Spotweb](https://github.com/spotweb/spotweb).
This setup is based on the work of [Jeroen Geusebroek](https://github.com/jgeusebroek/docker-spotweb).
The changes I made were required to run it on raspberry pi with Debian 11.

## Requirements

You need a seperate MySQL / MariaDB server. This can of course be a (linked) docker container but also a dedicated database server.

If you would like to use docker-compose, a short guide can be found [below](#docker-compose). Thanks to [Daniel Jongepier](https://github.com/djongepier).

## Usage

### Initial Installation

First create a database on your database server, and make sure the container has access to the database, then run a temporary container.

	docker run -it --rm -p 8085:80 \
		-e TZ='Europe/Amsterdam' \
		tgiesela/spotweb

Please NOTE that there is no database configuration here, this will enable the install process.

The run the Spotweb installer using the web interface: 'http://yourhost/install.php'.
This will create the necessary database tables and users. Ignore the warning when it tries to save the configuration.

When you are done, exit the container (CTRL/CMD-c) and configure the permanent running container.

### Permanent installation

	docker run --restart=always -d -p 8085:80 \
		--hostname=spotweb \
		--name=spotweb \
		-v <hostdir_where_config_will_persistently_be_stored>:/config \
		-e 'TZ=Europe/Amsterdam' \
		-e 'SPOTWEB_DB_TYPE=pdo_mysql' \
		-e 'SPOTWEB_DB_HOST=<database_server_hostname>' \
		-e 'SPOTWEB_DB_PORT=<database_port>' \
		-e 'SPOTWEB_DB_NAME=spotweb' \
		-e 'SPOTWEB_DB_USER=spotweb' \
		-e 'SPOTWEB_DB_PASS=spotweb' \
		tgiesela/spotweb

Please NOTE that the volume is optional. Only necessary when you have special configuration settings.
The database port is also optional. If omitted it will use the standard port for MySQL / PostgreSQL.

You should now be able to reach the spotweb interface on port 8085.

### Automatic retrieval of new spots
To enable automatic retrieval, you need to setup a cronjob on either the docker host or within the container.
#### Automatic retrieval of new spots on the docker host
To enable automatic retrieval, you need to setup a cronjob on the docker host.

	*/15 * * * * docker exec spotweb su -l www-data -s /usr/local/bin/php /var/www/spotweb/retrieve.php >/dev/null 2>&1

This example will retrieve new spots every 15 minutes.
#### Automatic retrieval of new spots from within the container
To enable automatic retrieval from within the container, use the `SPOTWEB_CRON_RETRIEVE` variable to specify the cron timing for retrieval. For example as additional parameter to the `docker run` command:

    -e 'SPOTWEB_CRON_RETRIEVE=*/15 * * * *'


### Updates

The container will try to auto-update the database when a newer version is released.

### Docker compose

An example `docker-compose.yml` is included. Create your base directory and edit the environment variables to suit your needs. After the initial run (`docker-compose up -d`) you will need to remove the `<base_dir>/spotweb/dbsettings.inc.php` because otherwise the install process won't proceed. Don't worry, your settings won't be lost.

After you deleted the file, point your browser to your install (ie. [http://localhost:8085/install.php](http://localhost:8885/install.php)) and follow the installation procedure.

It might give you an error saying it can't write the settings to file. You can ignore this.

When this all is finished, restart spotweb using `docker-compose restart`. You should now have a working spotweb installation. (please note the `<base_dir>/spotweb/dbsettings.inc.php` file will be automatically recreated during the restart). 

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
