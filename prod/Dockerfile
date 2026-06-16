FROM escape000escape/php8.3-base

# =========================
# PHP-FPM
# =========================
ENV PM_MODE=dynamic
ENV PM_MAX_CHILDREN=50
ENV PM_START_SERVERS=3
ENV PM_MIN_SPARE_SERVERS=3
ENV PM_MAX_SPARE_SERVERS=10
ENV PM_MAX_REQUESTS=1000
ENV PM_CATCH_WORKERS_OUTPUT=1

# =========================
# OPCACHE
# =========================
ENV PHP_OPCACHE_PRELOAD=/app/config/preload.php
ENV PHP_OPCACHE_PRELOAD_USER=www-data
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_CLI_ENABLE=1
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=256
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER=128
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_REVALIDATE_FREQ=2
ENV PHP_OPCACHE_MAX_WASTED_PERCENTAGE=5
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=20000
ENV PHP_OPCACHE_LOG_VERBOSITY_LEVEL=1
ENV PHP_OPCACHE_ENABLE_FILE_OVERRIDE=1

# =========================
# SESSION https://github.com/phpredis/phpredis
# =========================
ENV SESSION_SAVE_HANDLER=redis
ENV SESSION_SAVE_PATH=tcp://redis:6379?weight=1\&auth=12345

# =========================
# PHP
# =========================
ENV MEMORY_LIMIT=128M
ENV UPLOAD_MAX_FILESIZE=10M
ENV MAX_FILE_UPLOADS=60
ENV POST_MAX_SIZE=64M
ENV REALPATH_CACHE_SIZE=4096K
ENV REALPATH_CACHE_TTL=600
ENV ERROR_LOG=/dev/stderr
ENV DATE_TIMEZONE=Europe/Moscow

# =========================
# System packages
# =========================
RUN apk update && apk upgrade

RUN set -eux; \
    apk add --no-cache \
        zlib \
        openssh \
        bzip2

RUN apk add --no-cache \
    libjpeg-turbo \
    freetype \
    libpq \
    libpng \
    icu \
    libxml2 \
    libxslt \
    openldap \
    imap \
    krb5 \
    libssh2 \
    krb5-libs \
    libzip \
    c-client

# =========================
# Build dependencies
# =========================
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        linux-headers \
        postgresql-dev \
        icu-dev \
        re2c \
        file \
        make \
        g++ \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libmemcached-dev \
        openldap-dev \
        libxml2-dev \
        libssh2-dev \
        libzip-dev \
        imap-dev \
        krb5-dev \
        openssl-dev \
        rabbitmq-c-dev \
        libxslt-dev \
        libgcrypt-dev

# =========================
# Redis
# =========================
RUN set -eux; \
    pecl install redis; \
    docker-php-ext-enable redis

# =========================
# Core PHP extensions
# =========================
RUN set -eux; \
    docker-php-ext-configure intl; \
    docker-php-ext-install intl; \
    docker-php-ext-enable intl; \
    docker-php-ext-install \
        pdo \
        pdo_pgsql \
        opcache \
        exif \
        bcmath \
        ldap \
        soap \
        pcntl; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j$(nproc) gd; \
    docker-php-ext-install -j$(nproc) zip; \
    PHP_OPENSSL=yes docker-php-ext-configure imap --with-imap --with-imap-ssl; \
    docker-php-ext-install imap

# =========================
# SSH2
# =========================
RUN set -eux; \
    pecl install ssh2-1.3.1; \
    docker-php-ext-enable ssh2

# =========================
# AMQP
# =========================
RUN set -eux; \
    mkdir -p /usr/src/php/ext/amqp; \
    curl -fsSL https://pecl.php.net/get/amqp \
        | tar xvz -C "/usr/src/php/ext/amqp" --strip 1; \
    docker-php-ext-install amqp

RUN apk add --no-cache rabbitmq-c

# =========================
# XSL
# =========================
RUN set -eux; \
    docker-php-ext-install -j$(nproc) xsl

# =========================
# Cleanup
# =========================
RUN apk del .build-deps

# =========================
# Configs
# =========================
RUN apk add --no-cache gettext

RUN mkdir -p /usr/local/etc/php/conf.d \
    && chown -R www-data:www-data /usr/local/etc/php/conf.d

RUN mkdir -p /usr/local/etc/php-fpm.d \
    && chown -R www-data:www-data /usr/local/etc/php-fpm.d

COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/www.conf.template
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini.template
COPY ./prod.ini /usr/local/etc/php/conf.d/prod.ini.template

WORKDIR /app

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
