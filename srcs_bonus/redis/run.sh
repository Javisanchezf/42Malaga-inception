#!/bin/sh

sed -i "s/# requirepass foobared/requirepass $REDIS_PASS/" /etc/redis.conf

redis-server /etc/redis.conf