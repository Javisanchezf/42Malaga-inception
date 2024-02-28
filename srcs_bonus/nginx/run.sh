#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

export CRT=$DOMAIN_NAME.crt
export KEY=$DOMAIN_NAME.key
export FAST_CGI_PASS=wordpress:9000

# Create SSL certificate
if [ ! -f /etc/nginx/ssl/$KEY ] || [ ! -f /etc/nginx/ssl/$CRT ]; then
    echo -e "${GREEN}Creating SSL certificate for $DOMAIN_NAME...${NC}"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/$KEY -out /etc/nginx/ssl/$CRT -subj "/C=$CRT_COUNTRY/L=$CRT_LOCATION/O=$CRT_ORG/OU=$CRT_ORG_UNITY/CN=$DOMAIN_NAME"
else
    echo -e "${YELLOW}SSL certificate for $DOMAIN_NAME already exists${NC}"
fi

# Create nginx configuration file
if [ ! -f /etc/nginx/http.d/$DOMAIN_NAME.conf ]; then
    echo -e "${GREEN}Creating nginx configuration file for $DOMAIN_NAME...${NC}"
    envsubst '$DOMAIN_NAME $CRT $KEY $FAST_CGI_PASS' < /nginx_template.conf > /etc/nginx/http.d/$DOMAIN_NAME.conf
else
    echo -e "${YELLOW}Configuration file for $DOMAIN_NAME already exists${NC}"
fi

####################################################################################################

# Create nginx configuration file for the static website
if [ ! -f /etc/nginx/http.d/web.$DOMAIN_NAME.conf ]; then
    echo -e "${GREEN}Creating nginx configuration file for web.$DOMAIN_NAME...${NC}"
    tmp=$DOMAIN_NAME
    DOMAIN_NAME=web.$tmp
    envsubst '$DOMAIN_NAME $CRT $KEY $FAST_CGI_PASS' < /nginx_template.conf > /etc/nginx/http.d/$DOMAIN_NAME.conf
    # sed -i "s/wordpress:9000/adminer:9001/g" /etc/nginx/http.d/$DOMAIN_NAME.conf
    DOMAIN_NAME=$tmp
else
    echo -e "${YELLOW}Configuration file for web.$DOMAIN_NAME already exists${NC}"
fi

####################################################################################################

# # Create nginx configuration file for the static website
if [ ! -f /etc/nginx/http.d/adminer.$DOMAIN_NAME.conf ]; then
    echo -e "${GREEN}Creating nginx configuration file for adminer.$DOMAIN_NAME...${NC}"
    tmp=$DOMAIN_NAME
    DOMAIN_NAME=adminer.$tmp
    FAST_CGI_PASS=adminer:9001
    envsubst '$DOMAIN_NAME $CRT $KEY $FAST_CGI_PASS' < /nginx_template.conf > /etc/nginx/http.d/$DOMAIN_NAME.conf
    DOMAIN_NAME=$tmp
else
    echo -e "${YELLOW}Configuration file for adminer.$DOMAIN_NAME already exists${NC}"
fi

####################################################################################################

if [ ! -f /etc/nginx/http.d/netdata.$DOMAIN_NAME.conf ]; then
    echo -e "${GREEN}Creating nginx configuration file for netdata.$DOMAIN_NAME...${NC}"
    tmp=$DOMAIN_NAME
    DOMAIN_NAME=netdata.$tmp
    envsubst '$DOMAIN_NAME $CRT $KEY' < /netdata.conf > /etc/nginx/http.d/$DOMAIN_NAME.conf
    DOMAIN_NAME=$tmp
else
    echo -e "${YELLOW}Configuration file for netdata.$DOMAIN_NAME already exists${NC}"
fi

encrypted_password=$(openssl passwd -apr1 "$NETDATA_PASS")
echo "$NETDATA_USR:$encrypted_password" >> /etc/nginx/.htpasswd

# ###############################################################################################

# Start nginx
echo -e "${GREEN}Starting nginx...${NC}"
nginx -g "daemon off;"