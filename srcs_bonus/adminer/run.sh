#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if ! [ -f /domains/adminer.$DOMAIN_NAME/public_html/index.php ]; then
    mkdir -p /domains/adminer.$DOMAIN_NAME/public_html
    wget -O /domains/adminer.$DOMAIN_NAME/public_html/index.php https://github.com/vrana/adminer/releases/download/v4.7.8/adminer-4.7.8.php
    chown -R www-data:www-data /domains/adminer.$DOMAIN_NAME
    echo -e "${GREEN}Adminer has been installed${NC}"
else
    echo -e "${RED}Adminer is already installed${NC}"
fi


# Start PHP-FPM
echo -e "${GREEN}Starting PHP-FPM...${NC}"
php-fpm -FR