FROM php:8.3-fpm-alpine
# https://hub.docker.com/_/alpine

RUN apk update && \
    apk upgrade 

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/tmp
ENV COMPOSER_VERSION=2.9.8

RUN cd /tmp \
 && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php -r "copy('https://composer.github.io/installer.sig', 'composer.sig');" \
 && php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
 && php composer-setup.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && php -r "unlink('composer-setup.php');"

RUN set -ex apk --no-cache add git openssh-client

