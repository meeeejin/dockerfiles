# MySQL 5.7 with LinkBench

You can build a MySQL 5.7 instance with [LinkBench](https://github.com/facebookarchive/linkbench) installed via the [lb-mysql](https://hub.docker.com/r/meeeejin/lb-mysql) image. The default `MYSQL_ROOT_PASSWORD` is `vldb1234`, but you can change the value.

## Preinstalled Packages for Monitoring

- procps
- sysstat
- smartmontools
- blktrace

## How to use

1. Pull the image:

```bash
$ sudo docker pull meeeejin/lb-mysql:latest
Pulling repository registry
...
```

2. Check the downloaded image:

```
$ sudo docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
meeeejin/lb-mysql   latest              6934971ecdb7        41 minutes ago      649MB
...
```

3. Run the image:

```bash
$ mkdir datadir
$ mkdir logdir
$ sudo chown -R 999:docker datadir
$ sudo chown -R 999:docker logdir
$ sudo docker run -it \
  --name test \
  -v /path/to/host/datadir:/var/lib/mysql \
  -v /path/to/host/logdir:/var/log/mysql \
  meeeejin/lb-mysql:latest
```

4. Check the status of the created container:

```bash
$ sudo docker ps
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                               NAMES
2fdb277c41aa        meeeejin/lb-mysql:latest   "docker-entrypoint.s…"   8 minutes ago       Up 8 minutes        3306/tcp, 33060/tcp                 test
```

### Load Data

1. Create a new database called `linkdb` and the needed tables:

```bash
$ cd linkbench
$ mysql -uroot -pvldb1234

mysql> create database linkdb;

mysql> use linkdb;

mysql> CREATE TABLE `linktable` (
  `id1` bigint(20) unsigned NOT NULL DEFAULT '0',
  `id2` bigint(20) unsigned NOT NULL DEFAULT '0',
  `link_type` bigint(20) unsigned NOT NULL DEFAULT '0',
  `visibility` tinyint(3) NOT NULL DEFAULT '0',
  `data` varchar(255) NOT NULL DEFAULT '',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `version` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (link_type, `id1`,`id2`),
  KEY `id1_type` (`id1`,`link_type`,`visibility`,`time`,`id2`,`version`,`data`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 PARTITION BY key(id1) PARTITIONS 16;

CREATE TABLE `counttable` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `link_type` bigint(20) unsigned NOT NULL DEFAULT '0',
  `count` int(10) unsigned NOT NULL DEFAULT '0',
  `time` bigint(20) unsigned NOT NULL DEFAULT '0',
  `version` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`link_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `nodetable` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(10) unsigned NOT NULL,
  `version` bigint(20) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `data` mediumtext NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

2. Make a copy of the example config file:

```bash
$ cp config/LinkConfigMysql.properties config/MyConfig.properties
```

Open `MyConfig.properties` and change the MySQL connection information. For example:

```bash
# MySQL connection information
host = localhost
user = root
password = vldb1234
port = 3306
dbid = linkdb
```

If you want to change the scale of the benchmark, open `FBWorkload.properties` and increase the value of `maxid1` to get a larger database:

```bash
  # start node id (inclusive)
  startid1 = 1

  # end node id for initial load (exclusive)
  # With default config and MySQL/InnoDB, 1M ids ~= 1GB
  maxid1 = 10000001
```

3. Load the data:

```bash
$ ./bin/linkbench -c config/MyConfig.properties -l
```

### Start Benchmark

Run the request phase:

```bash
$ ./bin/linkbench -c config/MyConfig.properties -r
```

LinkBench supports the output of statistics in csv format for easier analysis. There are two categories of statistics: the final summary and per-thread statistics output periodically through the benchmark. -csvstats controls the former and -csvstream the latter:

```bash
$ ./bin/linkbench -c config/MyConfig.properties -csvstats final-stats.csv -csvstream streaming-stats.csv -r
```