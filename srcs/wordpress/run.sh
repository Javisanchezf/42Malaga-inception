#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}Creating WordPress folder: /domains/$DOMAIN_NAME/public_html${NC}"
mkdir -p /domains/$DOMAIN_NAME/public_html
cd /domains/$DOMAIN_NAME/public_html

echo -e "${GREEN}Creating www-data user and group...${NC}"
adduser -D -H -S -G www-data www-data
chown -R www-data:www-data /domains/$DOMAIN_NAME/public_html


echo -e "${GREEN}Downloading WordPress..."
wp core download --allow-root

wait_for_database() {
    until nc -z -v -w5 "$DB_HOST" 3306; do
        echo -e "${YELLOW}Waiting for the database to be available...${NC}"
        sleep 1
    done
}

wait_for_database

echo -e "${GREEN}Creating WordPress configuration file...${NC}"
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
        echo -e "${RED}Failed to install WordPress. Retrying in 1 second...${NC}"
        sleep 1
    fi
done

echo -e "${GREEN}Creating an example user...${NC}"
wp user create example example@example.com --role=author --user_pass=forty-two --allow-root

echo -e "${GREEN}Installing and updating WordPress plugins...${NC}"
wp plugin update --all --allow-root

echo -e "${GREEN}Rewriting WordPress permalinks...${NC}"
wp rewrite structure '/%postname%/' --hard

echo -e "${GREEN}Configuring PHP-FPM...${NC}"
sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php*/php-fpm*.d/www.conf

echo -e "${GREEN}Starting PHP-FPM...${NC}"
php-fpm -FR
