# PostgreSQL

## Installing PostgreSQL

1. Run the command to install PostgreSQL

   ```bash
    $ sudo apt-get install postgresql postgresql-contrib
   ```

   It will install below packages

   ```
    libcommon-sense-perl libjson-perl libjson-xs-perl libllvm11 libpq5 libtypes-serialiser-perl postgresql postgresql-13 postgresql-client-13 postgresql-client-common postgresql-common postgresql-contrib sysstat
   ```

2. Config files are here

   ```bash
   /etc/postgresql/13/main/pg_hba.conf          # authentication file
   /etc/postgresql/13/main/postgresql.conf      # configuration file
   ```

3. This installation created a new user called `postgres` without any password, as seen from `/etc/shadow`. You can change the password.

   ```bash
   $ sudo passwd postgres
   $ sudo su - postgres
   ```

4. To access postgres from your account (rather than from newly created postgres user), you need to create user and database in postgresql with the same name

   ```bash
   $ sudo su - postgres
   $ createuser --interactive
   $ createdb bhavyai
   ```

5. Now check your connection information

   ```
   $ psql
   > \conninfo
   ```

6. Now check all the users and the databases

   ```
   > \du+
   > \l+
   ```

## Setting password

By default, there is no password for postgres users. So, we need to set password if we want to use `md5` authentication.

1. First make the peer connection and connect

   ```bash
   $ su - <postgres username>
   $ psql
   ```

2. Change the password

   ```bash
   $ ALTER USER <postgres username> WITH PASSWORD '<new password>';
   ```

## Setup password authentication

Below are the default contents of the file `/etc/postgresql/13/main/pg_hba.conf`

```
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
```

The above means -

1. When you connect directly to the database on localhost, then `peer` authentication is used. This means connecting unix user and postgres user should be the same. To connect like this way, first switch to the unix user and then just run psql.

   ```
   $ su - postgres
   $ psql
   ```

2. When you connect to the database when specifying the IP address, then `md5` authentication is used. This means the hashed password is sent over the network. To connect like this way, specify the hostname and the username.

   ```
   $ psql -h localhost -U postgres -W
   $ psql -h 127.0.0.1 -U postgres -W

   ```

## Change database

```
> \c <database name>
```

## List users

```
> \du+
```

## List tables

```
> \dt+
```
