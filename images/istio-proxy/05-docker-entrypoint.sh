#!/usr/bin/env sh
set -eu
envsubst < /etc/nginx/conf.d/default.conf.temp > /etc/nginx/conf.d/default.conf
exec "$@"
