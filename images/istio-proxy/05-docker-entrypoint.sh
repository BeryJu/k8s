#!/usr/bin/env sh
set -eu
envsubst '${INT_HOST}' < /etc/nginx/conf.d/default.conf.temp > /etc/nginx/conf.d/default.conf
exec "$@"
