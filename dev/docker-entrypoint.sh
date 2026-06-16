#!/bin/sh
set -e

envsubst < /usr/local/etc/php/conf.d/dev.ini.template > /usr/local/etc/php/conf.d/zz-dev.ini
envsubst < /usr/local/etc/php-fpm.d/www.conf.template > /usr/local/etc/php-fpm.d/www.conf
envsubst < /usr/local/etc/php/conf.d/xdebug.ini.template > /usr/local/etc/php/conf.d/zz-xdebug.ini
envsubst < /usr/local/etc/php/conf.d/opcache.ini.template > /usr/local/etc/php/conf.d/opcache.ini

exec "$@"
