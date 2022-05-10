# Setting up MySQL Server

Instructions are for setting up MySQL Server on a Red Hat based distro.

## Installing the server

1. Run the command to install MySQL. This will install both the client and server.

   ```
   # dnf install community-mysql-server
   ```

2. Start the server

   ```
   # systemctl start mysqld.service
   ```

3. Configure for first use. The command asks setup questions. Put the answer as suggested in the table

   ```
   # mysql_secure_installation
   ```

   | Option                                | Suggested value           |
   | ------------------------------------- | ------------------------- |
   | Validate password component           | n                         |
   | Set the root password                 | sqlroot                   |
   | Remove anonymous users                | y                         |
   | Disallow remote root login            | n (looks like it ignores) |
   | Remove "test" database and its access | n (looks like it ignores) |
   | Reload priviledge tables              | yes                       |

4. Connecting to the root user. Use this to connect from the same machine on which server is running

   ```
   $ mysql -u root -p
   ```

## Setting up remote connection

1. Open the port and service on the active firewall

   ```
   # firewall-cmd --permanent --zone=FedoraServer --add-port=3306/tcp
   # firewall-cmd --permanent --zone=FedoraServer --add-service=mysql
   ```

2. Restart the firewall

   ```
   # systemctl restart firewalld.service
   ```

3. Allow `root` user for remote login

   ```
   > UPDATE mysql.user SET host='%' where user='root';
   > FLUSH PRIVILEGES;
   ```

4. Now connect to the ip and port 3306 on which MySQL server is running. An example for windows

   ```
   $ "C:\Program Files\MySQL Workbench\mysql.exe" -u root -p -h <ip-addr>
   ```

## Create another user

1. Create a new user that can be accessed remotely

   ```
   > CREATE USER 'delta'@'%' IDENTIFIED BY 'sqldelta';
   ```

2. Give grants to the new user to access everthing

   ```
   > GRANT ALL PRIVILEGES ON *.* TO 'delta'@'%';
   ```

3. Check the users domain. If host says %, it means that user can be accessed from everywhere
   ```
   > SELECT USER, HOST FROM mysql.user;
   ```
