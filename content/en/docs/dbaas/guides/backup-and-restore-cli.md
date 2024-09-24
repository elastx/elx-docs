---
title: "Backup and Restore via CLI"
description: "Backup and Restore databases with the help of CLI tools"
weight: 1
alwaysopen: true
---

## Overview
This guide will help you getting started with creating and restoring your own backups using various database CLI tools.  
For the build-in backup functionality, please see [here](../backup-and-restore-ui/).

## PostgreSQL
### Backup
The client we are using in this guide is `pg_dump` which is included in the PostgreSQL client package. It is recommended to use the same client version as your server version.

The basic syntax and an example to dump a PostgreSQL database with the official tool `pg_dump` is shown below. 
To connect and authenticate with a remote host you can either specify this information either with options, environment variables or a password file.

#### Usage & example
```shell
pg_dump [OPTION]... [DBNAME]
  -h, --host=HOSTNAME      database server host or socket directory (default: "local socket")
  -p, --port=PORT          database server port (default: "5432")
  -U, --username=USERNAME  database user name (default: "$USER")
  -f, --file=FILENAME      output file or directory name
  -d, --dbname=DBNAME      database to dump
```
```shell
pg_dump -h mydatabaseserver -U mydatabaseuser -f dump.sql -d mydatabase
```

#### Environment variables
As mentioned, we can also specify the options, connection and authentication information via environment variables, by default the client checks if the below environment variables are set.

For a full list, check out the documentation under [PostgreSQL Documentation](#postgresql-documentation).

```shell
PGDATABASE
PGHOST
PGOPTIONS
PGPORT
PGUSER
```

> It is not recommended to specify the password via the above methods, and thus not listed here. For the password it is better to use a so called password file. By default the client checks the user's home directory for a file named `.pgpass`. Read more about the password file by going to the official documentation linked under [PostgreSQL Documentation](#postgresql-documentation).

### Restore
To restore a database we will use the client `psql` which is also included in the PostgreSQL client package. It is recommended to use the same client version as your server version.

#### Usage & example
```shell
psql [OPTION]... [DBNAME [USERNAME]]
  -h, --host=HOSTNAME      database server host or socket directory (default: "local socket")
  -p, --port=PORT          database server port (default: "5432")
  -U, --username=USERNAME  database user name (default: "$USER")
  -f, --file=FILENAME      execute commands from file, then exit
  -d, --dbname=DBNAME      database name to connect to
```
```shell
psql -h mydatabaseserver -U mydatabaseuser -f dump.sql -d mydatabase
```

### PostgreSQL Documentation
- PostgreSQL [11](https://www.postgresql.org/docs/11/app-pgdump.html)/[14](https://www.postgresql.org/docs/14/app-pgdump.html) - pgdump
- PostgreSQL [11](https://www.postgresql.org/docs/11/libpq-pgpass.html)/[14](https://www.postgresql.org/docs/14/libpq-pgpass.html) - The Password file
- PostgreSQL [11](https://www.postgresql.org/docs/11/libpq-envars.html)/[14](https://www.postgresql.org/docs/14/libpq-envars.html) - Environment variables
- PostgreSQL [11](https://www.postgresql.org/docs/11/backup-dump.html)/[14](https://www.postgresql.org/docs/14/backup-dump.html) - SQL Dump

## MariaDB
### Backup
The client we are using in this guide is `mariadb-dump` which is included in the MariaDB client package.

The basic syntax and an example to dump a MariaDB database with the official tool `mariadb-dump` is shown below together with some of the options we will use.

#### Usage & example
```shell
mariadb-dump [OPTIONS] database [tables]
OR     mariadb-dump [OPTIONS] --databases DB1 [DB2 DB3...]
-h, --host=name       Connect to host.
-B, --databases       Dump several databases...
-q, --quick           Don't buffer query, dump directly to stdout.
--single-transaction  Creates a consistent snapshot by dumping all tables
                      in a single transaction...
--skip-lock-tables    Disable the default setting to lock tables
```

For a full list of options, check out the documentation under [MariaDB Documentation](#mariadb-documentation).
> Depending on your specific needs and the scope of the backup you might need to use the pre-created database user. This is because any subsequent users created in the portal are set up with permissions to a specific database while the pre-existing admin user have more global permissions that are needed for some of the dump options.

```shell
mariadb-dump -h mydatabaseserver -B mydatabase --quick --single-transaction --skip-lock-tables > dump.sql
```

> It is not recommended to specify the password via the command line. Consider using an option file instead, by default the client checks the user's home directory for a file named `.my.cnf`. You can read more about option files in the official documentation linked under [MariaDB Documentation](#mariadb-documentation).

### Restore
To restore the database from the dump file we will use the tool `mariadb` that is also included in the MariaDB client package.

#### Usage & example
```shell
mariadb [OPTIONS] [database]
-h, --host=name     Connect to host
```

```shell
mariadb -h mydatabaseserver mydatabase < dump.sql
```

### MariaDB Documentation
- MariaDB [mariadb-dump tool](https://mariadb.com/kb/en/mariadb-dump/)
- MariaDB [Option Files](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/)
- MariaDB [Backup and Restore Overview](https://mariadb.com/kb/en/backup-and-restore-overview/)

## MySQL
### Backup
The client we are using in this guide is `mysqldump` which is included in the MySQL client package.

The basic syntax and an example to dump a MySQL database with the official tool `mysqldump` is shown below together with some of the options we will use.

#### Usage & example
```shell
mysqldump [OPTIONS] database [tables]
OR     mysqldump [OPTIONS] --databases DB1 [DB2 DB3...]
-h, --host=name       Connect to host.
-B, --databases       Dump several databases...
-q, --quick           Don't buffer query, dump directly to stdout.
--single-transaction  Creates a consistent snapshot by dumping all tables
                      in a single transaction...
--skip-lock-tables    Disable the default setting to lock tables
--no-tablespaces      Do not write any CREATE LOGFILE GROUP or 
                      CREATE TABLESPACE statements in output 
```

For a full list of options, check out the documentation under [MySQL Documentation](#mysql-documentation).
> Depending on your specific needs and the scope of the backup you might need to use the pre-created database user. This is because any subsequent users created in the portal are set up with permissions to a specific database while the pre-existing admin user have more global permissions that are needed for some of the dump options.

```shell
mysqldump -h mydatabaseserver -B mydatabase --quick --single-transaction --skip-lock-tables --no-tablespaces > dump.sql`
```

> It is not recommended to specify the password via the command line. Consider using an option file instead, by default the client checks the user's home directory for a file named `.my.cnf`. You can read more about option files in the official documentation linked under [MySQL Documentation](#mysql-documentation).

### Restore
To restore the database from the dump file we will use the tool `mysql` that is also included in the MySQL client package.

#### Usage & example
```shell
mysql [OPTIONS] [database]
-h, --host=name     Connect to host
```

```shell
mysql -h mydatabaseserver mydatabase < dump.sql
```

### MySQL Documentation
- MySQL [mysqldump tool](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)
- MySQL [Option Files](https://dev.mysql.com/doc/refman/8.0/en/option-files.html)
- MySQL [Backup and Recovery](https://dev.mysql.com/doc/refman/8.0/en/backup-and-recovery.html)

