#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Wait for the database to be available
while ! mariadb -h$DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME &>/dev/null; do
    echo -e "${YELLOW}Waiting for the database to be available...${NC}"
    sleep 2
done

# Check if WordPress is already installed
if ! [ -f /domains/$DOMAIN_NAME/public_html/wp-config.php ]; then

    # Create WordPress folder and set permissions
    echo -e "${GREEN}Creating WordPress folder: /domains/$DOMAIN_NAME/public_html${NC}"
    mkdir -p /domains/$DOMAIN_NAME/public_html
    cd /domains/$DOMAIN_NAME/public_html
    chown -R www-data:www-data /domains/$DOMAIN_NAME/public_html

    # Download WordPress
    echo -e "${GREEN}Downloading WordPress...${NC}"
    wp core download --allow-root

    # Create WordPress configuration file
    echo -e "${GREEN}Creating WordPress configuration file...${NC}"
    wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASS" \
    --dbhost="$DB_HOST" \
    --dbcharset=utf8mb4 \
    --dbcollate=utf8mb4_general_ci \
    --extra-php <<PHP
    define('AUTOMATIC_UPDATER_DISABLED', true);
    define('WP_LIMIT_LOGIN_ATTEMPTS', true);
    define('WP_DEBUG', true);
    define('WP_DEBUG_LOG', true);
    define('WP_DEBUG_DISPLAY', false);
    define('WP_AUTO_UPDATE_CORE', 'minor');
    define('WP_POST_REVISIONS', false);
    define('EMPTY_TRASH_DAYS', 7);
    define('WP_MEMORY_LIMIT', '256M');
    define('WP_REDIS_HOST', 'redis');
    define('WP_REDIS_PORT', 6379);
PHP
    wp config shuffle-salts --allow-root
    
    # Install WordPress
    exit_code=1
    while [ "$exit_code" -ne 0 ]; do
        wp core install --url="$DOMAIN_NAME" --title="$DOMAIN_NAME" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL" --allow-root
        exit_code=$?
        if [ "$exit_code" -ne 0 ]; then
            echo -e "${RED}Failed to install WordPress. Retrying in 1 second...${NC}"
            sleep 1
        fi
    done

    # Create an example user, installing/updating plugins/themes and rewrite permalinks
    echo -e "${GREEN}Creating an example user...${NC}"
    wp user create example example@example.com --role=author --user_pass=forty-two --allow-root
    echo -e "${GREEN}Installing and updating WordPress plugins...${NC}"
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
    wp plugin update --all --allow-root
    echo -e "${GREEN}Rewriting WordPress permalinks...${NC}"
    wp rewrite structure '/%postname%/' --hard
else
    echo -e "${GREEN}WordPress is already installed. Skipping installation...${NC}"
fi

# Start PHP-FPM
if pgrep php-fpm; then
    echo -e "${RED}PHP-FPM is already running${NC}"
else
    echo -e "${GREEN}Starting PHP-FPM...${NC}"
    php-fpm -FR
fi
