FROM php:7-fpm

ENV REFRESHED_AT 21-09-2017

RUN apt-get update && apt-get install -y \
       git \
       apt-transport-https \
       vim \
       telnet \
       cron \
       zlib1g-dev \
       libfreetype6-dev \
       libjpeg62-turbo-dev \
       libmemcached-dev \
       libz-dev \
       libapache2-mod-rpaf \
       libmagickwand-dev \
       libmcrypt-dev \
       libxml2 \
       libxml2-dev \
       libpng12-dev \
       libicu-dev \
       php-pear \
       pkg-config \
       python-pip \
       make \
       openssl \
       libssl-dev \
       libcurl4-openssl-dev

RUN pip install supervisor \
    && pecl install mongodb xdebug imagick memcached \
    && docker-php-ext-enable imagick memcached \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install xml opcache zip mysqli pdo pdo_mysql gd intl mcrypt bcmath \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongodb.ini

# Add application directory
RUN mkdir -p /var/www/web

# Add users, add root rights, add alias for phpunit
RUN adduser developer --home /home/developer --uid 1001 \
    --shell /bin/bash \
    --disabled-password \
    --gecos "" && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "alias phpunit='php /var/www/vendor/bin/phpunit'" >> /home/developer/.bashrc

# Some cleanup
RUN apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN chown -R developer:developer /var/www/*

# Starting directory
WORKDIR /var/www