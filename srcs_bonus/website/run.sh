#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if ! [ -f /domains/web.$DOMAIN_NAME/public_html/index.html ]; then
	mkdir -p /domains/web.$DOMAIN_NAME/public_html && pandoc README.md -o /domains/web.$DOMAIN_NAME/public_html/index.html
	echo -e "${GREEN}Index.html created${NC}"
else
	echo -e "${YELLOW}Website already exists${NC}"
fi
if ! [ -f /domains/web.$DOMAIN_NAME/public_html/srcs_bonus/website/media ]; then
	mkdir -p /domains/web.$DOMAIN_NAME/public_html/srcs_bonus/website/media
	mv -f web_media /domains/web.$DOMAIN_NAME/public_html/srcs_bonus/website/media
	echo -e "${GREEN}Media folder created${NC}"
else
	echo -e "${YELLOW}Media folder already exists${NC}"
fi

echo -e "${GREEN}Web started${NC}"
sh -c "while true; do read; done"