FROM debian:stable-slim
RUN apt update
RUN apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 wget
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN apt update && apt install -y php8.1 php8.1-mysql php8.1-curl php8.1-dom
RUN wget https://getcomposer.org/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN apt install -y npm

COPY ./laravel-boilerplate /root/laravel-boilerplate
COPY .env /root/laravel-boilerplate/.env
WORKDIR /root/laravel-boilerplate

RUN composer install
RUN php artisan key:generate
RUN php artisan migrate
RUN php artisan db:seed
RUN php artisan storage:link
RUN npm install
RUN npm run dev
