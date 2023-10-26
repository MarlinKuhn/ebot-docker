FROM creativeprojects/php-nodejs:7.4


RUN git clone https://github.com/deStrO/eBot-CSGO.git /app/eBot-CSGO

WORKDIR /app/eBot-CSGO

RUN npm install

RUN composer install

CMD ["php", "bootstrap.php"]
