#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL..."
while ! nc -z localhost 3306; do
  sleep 1
done
echo "MySQL is ready!"

# Install dependencies
composer install --no-interaction --prefer-dist --optimize-autoloader

# Generate key if not set
if [ -z "$(php artisan key:status | grep 'Application key')" ]; then
    php artisan key:generate
fi

# Run migrations
php artisan migrate --force

# Install Passport if needed
php artisan passport:install

# Cache configuration and routes
php artisan config:cache
php artisan route:cache

# Generate Swagger documentation
php artisan l5-swagger:generate

# Start PHP-FPM
php-fpm
