#!/bin/sh

mkdir -p /domains/$DOMAIN_NAME/public_html && \
wp core download --allow-root --path=/domains/$DOMAIN_NAME/public_html && \
mv /domains/$DOMAIN_NAME/public_html/wp-config-sample.php /domains/$DOMAIN_NAME/public_html/wp-config.php && \
wp config shuffle-salts --path=/domains/$DOMAIN_NAME/public_html

wp config set DB_NAME $DB_NAME --path=/domains/$DOMAIN_NAME/public_html
wp config set DB_USER $DB_USER --path=/domains/$DOMAIN_NAME/public_html
wp config set DB_PASSWORD $DB_PASSWORD --path=/domains/$DOMAIN_NAME/public_html
wp config set DB_HOST $DOMAIN_NAME --path=/domains/$DOMAIN_NAME/public_html

##############################################
wp config set DB_CHARSET utf8 --path=/domains/$DOMAIN_NAME/public_html
wp config set DB_COLLATE '' --path=/domains/$DOMAIN_NAME/public_html
wp config set AUTOMATIC_UPDATER_DISABLED true --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_LIMIT_LOGIN_ATTEMPTS true --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_DEBUG_LOG true --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_DEBUG_DISPLAY false --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_DEBUG true --path=/domains/$DOMAIN_NAME/public_html
# wp config set WP_CACHE true --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_AUTO_UPDATE_CORE minor --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_POST_REVISIONS 5 --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_MEMORY_LIMIT 96M --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_MAX_MEMORY_LIMIT 256M --path=/domains/$DOMAIN_NAME/public_html
wp config set WP_CRON_LOCK_TIMEOUT 60 --path=/domains/$DOMAIN_NAME/public_html

while true; do
    sleep 1
done