#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

mkdir -p /domains/web.$DOMAIN_NAME/public_html && pandoc README.md -o /domains/web.$DOMAIN_NAME/public_html/index.html
mdkir -p /domains/web.$DOMAIN_NAME/public_html/srcs_bonus/website
mv -f media /domains/web.$DOMAIN_NAME/public_html/srcs_bonus/website
echo -e "${GREEN}Website created${NC}"

sh -c "while true; do read; done"