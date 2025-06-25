FROM registry-1.docker.io/library/nginx:1.29.0

COPY ./nginx.conf /etc/nginx/conf.d/default.conf.temp
COPY ./05-docker-entrypoint.sh /docker-entrypoint.d/05-docker-entrypoint.sh
