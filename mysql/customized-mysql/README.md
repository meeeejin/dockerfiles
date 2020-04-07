# Standalone Customized MySQL 5.7

The `docker-compose.yml` describes how to build a MySQL 5.7 container with a customized configuration file (`my.cnf`).

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
$ sudo docker-compose up -d
Creating customized-mysql ... done
```

5. You can check the created MySQL container using the below command:

```bash
$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
48e005d67d90        mysql:5.7           "docker-entrypoint.s…"   53 minutes ago      Up 32 minutes       0.0.0.0:3306->3306/tcp, 33060/tcp   customized-mysql
```

6. Run the below command to connect to the created container's bash:

```bash
$ sudo docker exec -it customized-mysql bash
```

7. Check the modified server variables in MySQL as follows:

```bash
root@89bb80313ac4:/# mysql -uroot -p -e "show variables like '%log_files%'"
+---------------------------+-------+
| Variable_name             | Value |
+---------------------------+-------+
| innodb_log_files_in_group | 3     |
+---------------------------+-------+
```

The value of `innodb_log_files_in_group` was changed from 2 (default value) to 3 (the value set in `cnf/my.cnf`).