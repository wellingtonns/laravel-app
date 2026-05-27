FROM composer:2 AS vendor

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install \
    --no-interaction \
    --no-dev \
    --no-scripts \
    --prefer-dist \
    --optimize-autoloader

FROM php:8.4-cli

WORKDIR /var/www/html

COPY . .
COPY --from=vendor /app/vendor ./vendor

RUN cp .env.example .env \
    && php artisan key:generate --ansi

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
