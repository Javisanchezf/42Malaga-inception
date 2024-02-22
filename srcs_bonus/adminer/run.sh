#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if ! [ -f /domains/bonus.$DOMAIN_NAME/public_html/adminer.php ]; then
    mkdir -p /domains/bonus.$DOMAIN_NAME/public_html
    wget -O /domains/bonus.$DOMAIN_NAME/public_html/adminer.php https://github.com/vrana/adminer/releases/download/v4.7.8/adminer-4.7.8.php
    chown -R www-data:www-data /domains/bonus.$DOMAIN_NAME
    echo -e "${GREEN}Adminer has been installed${NC}"
else
    echo -e "${RED}Adminer is already installed${NC}"
fi

# Start PHP-FPM
if pgrep php-fpm; then
    echo -e "${RED}PHP-FPM is already running${NC}"
else
    echo -e "${GREEN}Starting PHP-FPM...${NC}"
    php-fpm -FR
fi
