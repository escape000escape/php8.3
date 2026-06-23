#!/bin/sh
set -e

envsubst < /usr/local/etc/php-fpm.d/www.conf.template > /usr/local/etc/php-fpm.d/www.conf
envsubst < /usr/local/etc/php/conf.d/opcache.ini.template > /usr/local/etc/php/conf.d/opcache.ini
envsubst < /usr/local/etc/php/conf.d/prod.ini.template > /usr/local/etc/php/conf.d/prod.ini

if [ "$1" = "php-fpm" ] || [ -z "$1" ]; then
    exec php-fpm
fi

exec "$@"
