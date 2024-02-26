#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

mkdir -p /domains/web.$DOMAIN_NAME/public_html && markdown README.md > /domains/web.$DOMAIN_NAME/public_html/index.html

sh -c "while true; do read; done"