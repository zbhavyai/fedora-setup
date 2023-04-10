# Setting up PostgreSQL Server

Instructions are for setting up PostgreSQL Server.

## Installing the server

1. Run the command to install PostgreSQL. This will install both the client and server.

   ```
   # dnf install postgresql-server
   ```

2. Run the initial setup, and then start the server.

   ```
   $ postgresql-setup --initdb
   # systemctl start postgresql.service
   ```

3. This installation created a new user called `postgres` without any password, as seen from `/etc/shadow`, and a database `postgres`. You would have to switch unix user to connect to the db for the first time:

   ```
   # su - postgres
   $ psql
   ```

   OR, equivalently:

   ```
   $ sudo -u postgres psql
   ```

## Basic configuration of the server

1. Connect using the `postgres` user.

   ```
   $ sudo -u postgres psql
   ```

2. Check the directory for the configuration files. Depending upon the OS, the configuration file may be located at `/var/lib/pgsql/data/*.conf` or `/etc/postgresql/<version>/main/*conf`.

   ```sql
   > select * from pg_settings where name='config_file';
   ```

3. To access postgresql database from your account rather than from newly created `postgres` unix user, you need to

   1. Either create new user and database in postgresql with the same names as unix username. It may not be a good idea, as it will lead to as many users as the databases.

   2. Or change some settings. To do so,

4. Create a password for `postgres` database user

   ```sql
   > ALTER USER postgres WITH PASSWORD '<new password>';
   ```

   OR

   ```
   > \password postgres
   ```

5. Open the `/var/lib/pgsql/data/pg_hba.conf` configuration file. In the table wherever the TYPE is `host`, change the METHOD to `md5`. Finally the `pg_hba.conf` file would look like this:

   ```
   # TYPE  DATABASE        USER            ADDRESS                 METHOD

   # "local" is for Unix domain socket connections only
   local   all             all                                     peer
   # IPv4 local connections:
   host    all             all             127.0.0.1/32            md5
   # IPv6 local connections:
   host    all             all             ::1/128                 md5
   # Allow replication connections from localhost, by a user with the
   # replication privilege.
   local   replication     all                                     peer
   host    replication     all             127.0.0.1/32            md5
   host    replication     all             ::1/128                 md5
   ```

6. Restart the service

   ```
   # systemctl restart postgresql.service
   ```

7. Now connect to the postgresql from any account.

   ```
   $ psql -h localhost -U postgres
   ```

8. If you have multiple databases, connect to them using

   ```
   $ psql -h localhost -U postgres -d <dbname>
   ```

9. Now you can check your connection information

   ```sql
   > \conninfo
   ```

## Setting up remote connection

1. Check if PostgreSQL is listening on public port. Result including `127.0.0.1:5432` shows that PostgreSQL is listening only for connects originating from the local computer. Result including `0 0.0.0.0:5432` shows that PostgreSQL is listening for all connections.

   ```
   $ netstat -nlp | grep 5432
   ```

2. To open up remote access, edit the file `/var/lib/pgsql/data/postgresql.conf`. Edit the parameters `listen_addresses` and `port` so that they look like this:

   ```
   listen_addresses = '0.0.0.0'
   port = 5432
   ```

3. Setup authentication for remote connections to the database. Edit the file `/var/lib/pgsql/data/pg_hba.conf`. Add the following lines:

   ```
   host    all             all             0.0.0.0/0               md5
   host    all             all             ::/0                    md5
   ```

4. Restart the service

   ```
   # systemctl restart postgresql.service
   ```

5. Open the port in the firewall

   ```
   # firewall-cmd --permanent --add-port=5432/tcp
   # firewall-cmd --reload
   ```

6. Now connect to the ip and port 5432 on which PostgreSQL server is running. Example,

   ```
   $ psql -h <ip addr> -U postgres -d <dbname>
   ```

## Creating new user (role)

User (or role) can be created using:

```
$ psql -h localhost -U postgres
> CREATE ROLE <username> WITH LOGIN CREATEDB PASSWORD '<password>';
```

OR

```
$ sudo -u postgres createuser --interactive --password <username>
```

## Creating new database

```
$ psql -h localhost -U postgres
> CREATE DATABASE <dbname> WITH OWNER <username>;
```

OR

```
$ sudo -u postgres createdb <database-name>
```

## Setting up automatic password

If you don't want to supply password on prompt each time when using `psql` command, below two are good options. These are useful when connecting to postgresql database using a script.

1. Using `PGPASSWORD` environment variable. Either set this variable globally, or just in the script, or use it in the command. To use it in the command

   ```
   $ PGPASSWORD='<password>' psql -h <host name> -U <username> -d <database name>
   ```

2. Using `.pgpass` file. By default, this file should be in the home directory, with permissions `600` only. It contains the password for each connection. Format is `hostname:port:database:username:password`. File contents would like this:

   ```
   *:*:*:<username>:<password>
   ```

## Same basic commands

| Command                                                   | Description                               |
| --------------------------------------------------------- | ----------------------------------------- |
| `\l+`                                                     | List all databases                        |
| `\c <database name>`                                      | Change database                           |
| `\du+`                                                    | List all users                            |
| `\d`                                                      | List all relations (eg tables, sequences) |
| `\dt+`                                                    | List tables only                          |
| `\dn+ <dbname>`                                           | List all schemas in a database            |
| `\d <table name>`                                         | List table details                        |
| `pg_dump -st <tablename> <dbname>`                        | Taking table dump                         |
| `pg_dump -s dbname`                                       | Taking database dump                      |
| `psql -h localhost -U <username> -d <dbname> -f filepath` | Load SQL script                           |
| `\q`                                                      | Exit                                      |
