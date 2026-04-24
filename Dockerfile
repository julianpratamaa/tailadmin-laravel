FROM php:8.1-apache

RUN apt update && apt install -y \
git curl unzip zip libzip-dev mariadb-client npm \
&& docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev
RUN cp .env.example .env || true
RUN php artisan key:generate || true

EXPOSE 80

CMD php artisan migrate --force || true && apache2-foreground
