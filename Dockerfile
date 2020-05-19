FROM php:7.4.5-fpm

LABEL maintainer="Michael Tam <michael@sunnyvision.com>"
LABEL maintainer="Michael Tam <h.y.michael@icloud.com>"

RUN apt-get update && apt-get upgrade -y \
    g++ \
    libzip-dev \
    libc-client-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libpq-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    libssl-dev \
    libssl-doc \
    libsasl2-dev \
    zlib1g-dev;

RUN apt-get update && apt-get upgrade -y libonig-dev;

RUN docker-php-ext-install \
    bz2 \
    iconv \
    mbstring \
    mysqli \
    pgsql \
    pdo_mysql \
    pdo_pgsql \
    soap \
    zip;

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick;

RUN PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos -with-imap-ssl \
    && docker-php-ext-install imap \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -Rf /tmp/*

# ffmpeg
RUN apt-get update && apt-get upgrade -y \
    ffmpeg
    
RUN docker-php-ext-install bcmath
