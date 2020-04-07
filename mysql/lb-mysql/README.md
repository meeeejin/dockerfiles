# MySQL 5.7 with LinkBench

You can build a MySQL 5.7 instance with [LinkBench](https://github.com/facebookarchive/linkbench) installed via the [lb-mysql](https://hub.docker.com/r/meeeejin/lb-mysql) image. You can check the simplified installation guide of LinkBench in [my GitHub repo](https://github.com/meeeejin/til/blob/master/benchmark/how-to-install-linkbench-on-ubuntu.md).

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
