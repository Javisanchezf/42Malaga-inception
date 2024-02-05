#!/bin/sh
if [ ! -d "/domains/$DOMAIN_NAME" ]; then
    mkdir -p /domains/$DOMAIN_NAME/public_html
    cd /domains/$DOMAIN_NAME/public_html
    wp core download --allow-root
    mv wp-config-sample.php wp-config.php
    wp config shuffle-salts

    wp config set DB_NAME $DB_NAME
    wp config set DB_USER $DB_USER
    wp config set DB_PASSWORD $DB_PASS
    wp config set DB_HOST $DB_HOST
    wp config set DB_CHARSET utf8
    wp config set DB_COLLATE ''

    ##############################################
    # wp config set WP_ALLOW_REPAIR true
    wp config set AUTOMATIC_UPDATER_DISABLED true
    wp config set WP_LIMIT_LOGIN_ATTEMPTS true
    wp config set WP_DEBUG true
    wp config set WP_DEBUG_LOG true
    wp config set WP_DEBUG_DISPLAY false
    wp config set WP_AUTO_UPDATE_CORE minor
    wp config set WP_POST_REVISIONS false
    wp config set WP_MEMORY_LIMIT 96M
    wp config set WP_MAX_MEMORY_LIMIT 256M
    wp config set WP_CRON_LOCK_TIMEOUT 60


    wp core install --url=$DOMAIN_NAME --title=$DOMAIN_NAME --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASS --admin_email=$ADMIN_EMAIL
    # wp config set FORCE_SSL_ADMIN true
    # wp config set WP_REDIS_HOST redis
    # wp define WP_REDIS_PORT 6379
    wp user create example example@example.com --role=author --user_pass=forty-two --allow-root
    # wp theme install astra --activate --allow-root
    # wp plugin install wp-fastest-cache --activate --allow-root
    wp plugin update --all --allow-root

    wp rewrite structure '/%postname%/' --hard
    #Execute the commands regardless of the installed version of php-fpm, this being the latest available
    sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php*/php-fpm*.d/www.conf
    mv /usr/sbin/php-fpm* /usr/sbin/php-fpm
    mv /usr/bin/php-fpm* /usr/bin/php-fpm
fi

php-fpm -FR
