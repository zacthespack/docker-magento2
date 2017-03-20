FROM php:7.1.3-apache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update \
   && docker-php-ext-install mbstring \
   && docker-php-ext-install pdo_mysql \
   && apt-get install -y libxml2-dev \
       && docker-php-ext-install soap \
   && apt-get install -y libmcrypt4 libmcrypt-dev \
       && docker-php-ext-install mcrypt \
   && apt-get install -y libxslt-dev \
       && docker-php-ext-install xsl \
   && apt-get install -y libicu-dev \
       && docker-php-ext-install intl \
   && apt-get install -y libpng12-dev libjpeg-dev libfreetype6-dev\
       && docker-php-ext-configure gd --with-jpeg-dir=/usr/lib --enable-gd-native-ttf --with-freetype-dir=/usr/lib \
       && docker-php-ext-install gd \
   && apt-get install -y zlib1g-dev unzip\
       && docker-php-ext-install zip  \
   && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && curl https://github.com/realtimedespatch/magento2/archive/develop.zip -Lko develop.zip  && unzip -o  develop.zip && mv magento2-develop/* magento2-develop/.htaccess /var/www/html

RUN chown -R www-data:www-data /var/www/html

RUN cd /var/www/html && composer install

COPY ./bin/install-magento /usr/local/bin/install-magento
RUN chmod +x /usr/local/bin/install-magento

RUN find var vendor pub/static pub/media app/etc -type f -exec chmod u+w {} \;
RUN find var vendor pub/static pub/media app/etc -type d -exec chmod u+w {} \;
RUN chmod u+x bin/magento
