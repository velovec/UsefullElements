#!/bin/bash

DB_NAME="wordpress_$(pwgen 5 1)"
DB_USER="word_$(pwgen 5 1)"
DB_PASSWORD=$(pwgen -s 15 1)

service mysql restart

mysql --user=root --password=root -e "CREATE DATABASE ${DB_NAME} CHARSET UTF8;"
mysql --user=root --password=root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${DB_USER}@localhost IDENTIFIED BY '${DB_PASSWORD}';"
mysql --user=root --password=root -e "FLUSH PRIVILEGES;"

sed -e "s/define('DB_NAME'.*$/define('DB_NAME', '${DB_NAME}');/" -i /var/www/html/wordpress/wp-config.php
sed -e "s/define('DB_USER'.*$/define('DB_USER', '${DB_USER}');/" -i /var/www/html/wordpress/wp-config.php
sed -e "s/define('DB_PASSWORD'.*$/define('DB_PASSWORD', '${DB_PASSWORD}');/" -i /var/www/html/wordpress/wp-config.php
sed -e "s/define('DB_HOST'.*$/define('DB_HOST', '127.0.0.1');/" -i /var/www/html/wordpress/wp-config.php

cat > /etc/motd <<-EOF

    Your WordPress installation is ready.

    MySQL DB Host: 127.0.0.1
    MySQL DB Name: $DB_NAME
    MySQL DB User: $DB_USER
    MySQL DB Password: $DB_PASSWORD

    This message can be deleted by removing /etc/motd

EOF

service apache2 restart
