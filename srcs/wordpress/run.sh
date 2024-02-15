#!/bin/sh
mkdir -p /domains/$DOMAIN_NAME/public_html
cd /domains/$DOMAIN_NAME/public_html
wp core download --allow-root
wp config create \
  --dbname="$DB_NAME" \
  --dbuser="$DB_USER" \
  --dbpass="$DB_PASS" \
  --dbhost="$DB_HOST" \
  --dbcharset=utf8mb4 \
  --dbcollate='utf8mb4_unicode_ci' \
  --extra-php <<PHP
define( 'AUTOMATIC_UPDATER_DISABLED', true );
define( 'WP_LIMIT_LOGIN_ATTEMPTS', true );
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_AUTO_UPDATE_CORE', 'minor' );
define( 'WP_POST_REVISIONS', false );
define( 'WP_MEMORY_LIMIT', '96M' );
define( 'WP_MAX_MEMORY_LIMIT', '256M' );
define( 'WP_CRON_LOCK_TIMEOUT', 60 );
PHP

wp config shuffle-salts --allow-root

exit_code=1

while [ "$exit_code" -ne 0 ]; do
    wp core install --url="$DOMAIN_NAME" --title="$DOMAIN_NAME" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL" --allow-root
    exit_code=$?
    if [ "$exit_code" -ne 0 ]; then
        sleep 1
    fi
done

wp user create example example@example.com --role=author --user_pass=forty-two --allow-root

wp plugin update --all --allow-root

wp rewrite structure '/%postname%/' --hard

sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php*/php-fpm*.d/www.conf

php-fpm -FR
