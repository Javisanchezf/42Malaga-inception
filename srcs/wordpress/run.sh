#!/bin/sh
if [ ! -d "/domains/$DOMAIN_NAME" ]; then
    mkdir -p /domains/$DOMAIN_NAME/public_html && \
    wp core download --allow-root --path=/domains/$DOMAIN_NAME/public_html && \
    mv /domains/$DOMAIN_NAME/public_html/wp-config-sample.php /domains/$DOMAIN_NAME/public_html/wp-config.php && \
    wp config shuffle-salts --path=/domains/$DOMAIN_NAME/public_html

    wp config set DB_NAME $DB_NAME --path=/domains/$DOMAIN_NAME/public_html
    wp config set DB_USER $DB_USER --path=/domains/$DOMAIN_NAME/public_html
    wp config set DB_PASSWORD $DB_PASS --path=/domains/$DOMAIN_NAME/public_html
    wp config set DB_HOST $DOMAIN_NAME --path=/domains/$DOMAIN_NAME/public_html

    ##############################################
    # WP_ALLOW_REPAIR
    wp config set DB_CHARSET utf8 --path=/domains/$DOMAIN_NAME/public_html
    wp config set DB_COLLATE 'utf8mb4_general_ci' --path=/domains/$DOMAIN_NAME/public_html
    wp config set AUTOMATIC_UPDATER_DISABLED true --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_LIMIT_LOGIN_ATTEMPTS true --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_DEBUG true --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_DEBUG_LOG true --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_DEBUG_DISPLAY false --path=/domains/$DOMAIN_NAME/public_html
    # wp config set WP_CACHE true --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_AUTO_UPDATE_CORE minor --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_POST_REVISIONS false --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_MEMORY_LIMIT 96M --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_MAX_MEMORY_LIMIT 256M --path=/domains/$DOMAIN_NAME/public_html
    wp config set WP_CRON_LOCK_TIMEOUT 60 --path=/domains/$DOMAIN_NAME/public_html
    wp core install --url=$DOMAIN_NAME --title=$DOMAIN_NAME --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASS --admin_email=$ADMIN_EMAIL --path=/domains/$DOMAIN_NAME/public_html
fi


while true; do
    sleep 1
done