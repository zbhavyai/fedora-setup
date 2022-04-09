# PostgreSQL

## Installing PostgreSQL

1. Run the command to install PostgreSQL. This will install both the client and server.

   ```
   # dnf install postgresql-server
   ```

2. Run the initial setup

   ```
   $ postgresql-setup --initdb
   ```

3. This installation created a new user called `postgres` without any password, as seen from `/etc/shadow`. You may have to switch to connect to the db for the first time

   ```
   $ sudo su - postgres
   ```

4. To connect to the database, start the server and connect from the `postgres` user

   ```sh
   $ sudo systemctl start postgresql.service
   $ psql
   ```

5. Check the directory for the configuration files. Depending upon the OS, the configuration file may be located at `/var/lib/pgsql/data/*.conf` or `/etc/postgresql/<version>/main/*conf`.

   ```sql
   > select * from pg_settings where name='config_file';
   ```

6. To access postgresql database from your account (rather than from newly created `postgres` user), you either need to create user and database in postgresql with the same name or you have to change some settings.

   1. Connect by creating another username and database

      1. Create a new user and database of the same name

         ```
         $ sudo su - postgres
         $ createuser --interactive
         $ createdb <same dbname as unix username>
         ```

      2. Now connect with that unix username
         ```
         $ psql
         ```

   2. Connect by changing some settings

      1. First connect to the database using `postgres` unix user

         ```
         $ sudo su - postgres
         $ psql
         ```

      2. Create a password for `postgres` database user

         ```
         > ALTER USER postgres WITH PASSWORD '<new password>';
         ```

      3. Open the `pg_hba.conf` configuration file. In the table wherever the TYPE is `host`, change the METHOD to `md5`. Finally the `pg_hba.conf` file would look like this -

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

      4. Restart the service

         ```
         $ sudo systemctl restart postgresql.service
         ```

      5. Now connect to the postgresql from any account

         ```
         $ psql -h localhost -U postgres
         ```

7. Now you can check your connection information

   ```
   > \conninfo
   ```

8. And check all the users and the databases

   ```
   > \du+
   > \l+
   ```

## Setting password

By default, there is no password for new postgres users added using `createuser` command. So, we need to set password if we want to use `md5` authentication.

1. First make the peer connection and connect

   ```
   $ su - <postgres username>
   $ psql
   ```

2. Change the password

   ```
   $ ALTER USER <postgres username> WITH PASSWORD '<new password>';
   ```

## Change database

```
> \c <database name>
```

## List users

```
> \du+
```

## List tables only

```
> \dt+
```

## List relations (eg tables, sequences, etc)

```
> \d
```

## Check table information

```
> \d <table name>
```

## Taking table dump

```
$ pg_dump -st <tablename> <dbname>
```
