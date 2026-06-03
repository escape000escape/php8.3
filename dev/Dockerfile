FROM escape000escape/php8.3-prod

# =========================
# XDEBUG ENV
# =========================
ENV PHP_MAX_EXECUTION_TIME=30

ENV PHP_XDEBUG_MODE=debug,develop,coverage,trace,profile
ENV PHP_XDEBUG_START_WITH_REQUEST=yes
ENV PHP_XDEBUG_OUTPUT_DIR=/tmp
ENV PHP_XDEBUG_DISCOVER_CLIENT_HOST=yes
ENV PHP_XDEBUG_CLIENT_HOST=host.docker.internal
ENV PHP_XDEBUG_CLIENT_PORT=9003
ENV PHP_XDEBUG_IDEKEY=PHPSTORM
ENV PHP_XDEBUG_MAX_NESTING_LEVEL=512
ENV PHP_XDEBUG_TIMEZONE=Europe/Moscow
ENV PHP_XDEBUG_MEMORY_LIMIT=256M

# =========================
# BUILD DEPS
# =========================
RUN set -eux; \
    apk add --no-cache \
        linux-headers \
        rabbitmq-c-dev \
        openssl-dev \
        curl; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        autoconf \
        g++ \
        make

RUN apk add --no-cache libzip-dev

RUN mkdir -p /app/config \
    && touch /app/config/preload.php

# =========================
# INSTALL AMQP
# =========================
RUN set -eux; \
    mkdir -p /usr/src/php/ext/amqp; \
    curl -fsSL https://pecl.php.net/get/amqp \
        | tar xvz -C /usr/src/php/ext/amqp --strip 1; \
    docker-php-ext-install amqp

# =========================
# INSTALL XDEBUG
# =========================
RUN set -eux; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug

# =========================
# CLEANUP
# =========================
RUN apk del .build-deps

# =========================
# VERIFY
# =========================
RUN php -m | grep xdebug

# =========================
# CONFIGS
# =========================
# COPY ./xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./xdebug.ini /usr/local/etc/php/conf.d/99-xdebug.ini
COPY ./dev.ini /usr/local/etc/php/conf.d/prod.ini
COPY ./fpm.conf /usr/local/etc/php-fpm.d/x.fpm.conf

# =========================
# WORKDIR
# =========================
WORKDIR /app