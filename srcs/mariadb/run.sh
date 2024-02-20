#!/bin/sh

# Start the services
rc-service mariadb restart

# Initial setup and cleaning of the database
mariadb -e "DROP DATABASE test;"
mariadb -e "DELETE FROM mysql.user WHERE User='';"
mariadb -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mariadb -e "FLUSH PRIVILEGES;"

# Create the database and the user
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS'"
mariadb -p$DB_ROOT_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mariadb -p$DB_ROOT_PASS -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
mariadb -p$DB_ROOT_PASS -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
mariadb -p$DB_ROOT_PASS -e "FLUSH PRIVILEGES;"

# Stop the services
rc-service mariadb stop

# Start the services in daemon mode
mariadbd --basedir=/usr --datadir=/var/lib/mysql --user=mysql