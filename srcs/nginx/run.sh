#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if [ ! -d /domains/$DOMAIN_NAME/public_html ]; then
    echo -e "${GREEN}Creating public_html directory for $DOMAIN_NAME...${NC}"
    mkdir -p /domains/$DOMAIN_NAME/public_html
else
    echo -e "${YELLOW}Public_html directory for $DOMAIN_NAME already exists${NC}"
fi

# Create SSL certificate
if [ ! -f /etc/nginx/ssl/$DOMAIN_NAME.key ] || [ ! -f /etc/nginx/ssl/$DOMAIN_NAME.crt ]; then
    echo -e "${GREEN}Creating SSL certificate for $DOMAIN_NAME...${NC}"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/$DOMAIN_NAME.key -out /etc/nginx/ssl/$DOMAIN_NAME.crt -subj "/C=$CRT_COUNTRY/L=$CRT_LOCATION/O=$CRT_ORG/OU=$CRT_ORG_UNITY/CN=$DOMAIN_NAME"
else
    echo -e "${YELLOW}SSL certificate for $DOMAIN_NAME already exists${NC}"
fi

# Create nginx configuration file
if [ ! -f /etc/nginx/http.d/$DOMAIN_NAME.conf ]; then
    echo -e "${GREEN}Creating nginx configuration file for $DOMAIN_NAME...${NC}"
    envsubst '$DOMAIN_NAME' < /nginx_template.conf > /etc/nginx/http.d/$DOMAIN_NAME.conf
else
    echo -e "${YELLOW}Configuration file for $DOMAIN_NAME already exists${NC}"
fi

# Start nginx
if pgrep nginx > /dev/null
then
    echo -e "${YELLOW}Nginx is already running${NC}"
    echo -e "${GREEN}Reloading nginx...${NC}"
    nginx -s reload
else
    echo -e "${GREEN}Starting nginx...${NC}"
    nginx -g "daemon off;"
fi