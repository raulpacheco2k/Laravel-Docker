FROM php:8-apache

# 1. Configuring Apache
ENV APPLICATION_NAME=Blog
RUN echo "ServerName ${APPLICATION_NAME}" >> /etc/apache2/apache2.conf

ENV APACHE_DOCUMENT_ROOT=/var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g'  /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g'      /etc/apache2/conf-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g'      /etc/apache2/apache2.conf

# 2. Development tools
RUN apt update && apt install -y \
    sudo \
    npm \
    nodejs \
    zip \
    unzip \
    git \
    curl \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++

# 3. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origi-
RUN a2enmod rewrite headers

# 4. Install dependencies laravel
RUN docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    pdo_mysql

# 5. Install composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
