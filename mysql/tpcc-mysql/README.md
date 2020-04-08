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

I've pushed the [tpcc-mysql](https://hub.docker.com/r/meeeejin/tpcc-mysql) image created through the above process to the Docker Hub. You can `pull` the [tpcc-mysql](https://hub.docker.com/r/meeeejin/tpcc-mysql) image directly from the Docker Hub. The default `MYSQL_ROOT_PASSWORD` is `vldb1234`, but you can change the value.

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
$ mkdir datadir
$ mkdir logdir
$ sudo chown -R 999:docker datadir
$ sudo chown -R 999:docker logdir
$ sudo docker run -it \
  --name test \
  -v /path/to/host/datadir:/var/lib/mysql \
  -v /path/to/host/logdir:/var/log/mysql \
  meeeejin/tpcc-mysql:latest
```

4. Check the status of the created container:

```bash
$ sudo docker ps
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                               NAMES
2fdb277c41aa        meeeejin/tpcc-mysql:latest   "docker-entrypoint.s…"   8 minutes ago       Up 8 minutes        3306/tcp, 33060/tcp                 test
```

### Load Data

1. Create a database for TPC-C test:

```bash
$ cd root/tpcc-mysql
$ mysql -u root -p -e "CREATE DATABASE tpcc100;"
$ mysql -u root -p tpcc100 < create_table.sql
$ mysql -u root -p tpcc100 < add_fkey_idx.sql
```

If the `load.sh` file does not have execute permission, add the permission.

```bash
$ chmod +x load.sh
```

2. Update the password in `load.sh`. For example:

```bash
export LD_LIBRARY_PATH=/usr/local/mysql/lib/mysql/
DBNAME=$1
WH=$2
HOST=127.0.0.1
STEP=100

./tpcc_load -h $HOST -d $DBNAME -u root -p "vldb1234" -w $WH -l 1 -m 1 -n $WH >> 1.out &

x=1

while [ $x -le $WH ]
do
 echo $x $(( $x + $STEP - 1 ))
./tpcc_load -h $HOST -d $DBNAME -u root -p "vldb1234" -w $WH -l 2 -m $x -n $(( $x + $STEP - 1 ))  >> 2_$x.out &
./tpcc_load -h $HOST -d $DBNAME -u root -p "vldb1234" -w $WH -l 3 -m $x -n $(( $x + $STEP - 1 ))  >> 3_$x.out &
./tpcc_load -h $HOST -d $DBNAME -u root -p "vldb1234" -w $WH -l 4 -m $x -n $(( $x + $STEP - 1 ))  >> 4_$x.out &
 x=$(( $x + $STEP ))
done
```

3. Run the load script:

```bash
$ load.sh tpcc100 100
```

In this case, database size is about 10 GB (= 100 warehouses).

### Start Benchmark

After loading, run tpcc-mysql test:

```bash
$ ./tpcc_start -h127.0.0.1 -dtpcc100 -uroot -pvldb1234 -w100 -c32 -r10 -l1200
```

It means:

- Host: 127.0.0.1
- DB: tpcc100
- User: root
- Password: vldb1234
- Warehouse: 100
- Connection: 32
- Rampup time: 10 (sec)
- Measure time: 1200 (sec)