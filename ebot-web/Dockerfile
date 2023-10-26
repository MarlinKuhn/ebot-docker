FROM php:5.6.20-fpm

WORKDIR /app

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN apt-get update && apt-get install -y --force-yes git && apt-get clean

RUN echo 'date.timezone = Europe/Paris' >> /usr/local/etc/php/conf.d/timezone.ini

RUN git config --global http.sslverify false

RUN mkdir eBot-CSGO-Web

RUN git clone https://github.com/deStrO/eBot-CSGO-Web.git temp

RUN cp -n -R temp/* eBot-CSGO-Web && rm -rf temp

COPY setup.sh .

RUN chmod +x setup.sh

CMD ["./setup.sh"]
