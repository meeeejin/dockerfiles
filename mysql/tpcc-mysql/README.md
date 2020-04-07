# MySQL 5.7 with tpcc-mysql

## Via `Dockfile` and `docker-compose.yml`

These files describe how to create a MySQL 5.7 container with a customized configuration file (`my.cnf`) and tpcc-mysql in a single container.

1. Edit `cnf/my.cnf` with the desired settings.

2. Modify all the absolute path in `docker-compose.yml`:

```bash
...
    volumes:
      - /path/to/host/datadir:/var/lib/mysql
      - /path/to/host/logdir:/var/log/mysql
      - /path/to/host/cnfdir:/etc/mysql/conf.d
...
```

- `/path/to/host/datadir`: The MySQL data directory of the host system
- `/path/to/host/logdir`: The MySQL log directory of the host system
- `/path/to/host/cnfdir`: The directory containing the customized `my.cnf` of the host system

3. Update `MYSQL_ROOT_PASSWORD` to your password:

```bash
...
    environment:
      MYSQL_ROOT_PASSWORD: "user-pw"
...
```

4. Run `docker-compose up`:

```bash
$ sudo docker-compose up -d --build
...
Creating tpcc-mysql ... done
```

5. You can check the created MySQL container using the below command:

```bash
$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
48e005d67d90        mysql:5.7           "docker-entrypoint.s…"   53 minutes ago      Up 32 minutes       0.0.0.0:3306->3306/tcp, 33060/tcp   tpcc-mysql
```

## Via Docker Hub

I've pushed the [tpcc-mysql](https://hub.docker.com/r/meeeejin/tpcc-mysql) image created through the above process to the Docker Hub. You can `pull` the [tpcc-mysql](https://hub.docker.com/r/meeeejin/tpcc-mysql) image directly from the Docker Hub.

1. Pull the image:

```bash
$ sudo docker pull meeeejin/tpcc-mysql:latest
Pulling repository registry
...
```

2. Check the downloaded image:

```
$ sudo docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
meeeejin/tpcc-mysql   latest              6934971ecdb7        41 minutes ago      649MB
...
```

3. Run the image:

```bash
$ sudo docker run -d --rm -it --name test meeeejin/tpcc-mysql:latest
```

4. Check the status of the created container:

```bash
$ sudo docker ps
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                               NAMES
2fdb277c41aa        meeeejin/tpcc-mysql:latest   "docker-entrypoint.s…"   8 minutes ago       Up 8 minutes        3306/tcp, 33060/tcp                 test
```