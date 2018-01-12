FROM ubuntu:16.04

MAINTAINER alessandro.minoccheri@studiomado.it

RUN apt-get update

RUN apt-get install -y software-properties-common

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get -y --no-install-recommends install git curl ca-certificates \
        php7.1-cli php7.1-curl php-apcu php-apcu-bc \
        php7.1-json php-sodium php7.1-mbstring php7.1-opcache php7.1-readline php7.1-xml php7.1-zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

RUN apt-get update
RUN apt-get install -y php7.1
RUN apt-get install -y php7.1-xml
RUN apt-get install -y php7.1-mbstring
RUN apt-get install -y php7.1-json
RUN apt-get install -y php7.1-gd
RUN apt-get install -y php7.1-mcrypt
RUN apt-get install -y php7.1-fpm
RUN apt-get install -y php7.1-pdo
RUN apt-get install -y php7.1-opcache
RUN apt-get install -y php7.1-soap
RUN apt-get install -y php7.1-xmlrpc
RUN apt-get install -y php7.1-simplexml
RUN apt-get install -y php7.1-curl
RUN apt-get install -y php7.1-mysqlnd
RUN apt-get install -y php-imagick
RUN apt-get install -y mysql-client
RUN apt-get install -y curl php7.1-cli
RUN apt-get install -y git
RUN apt-get install -y unzip

RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN touch /var/log/www.access.log

RUN sed -e 's/127.0.0.1:9000/0.0.0.0:9000/' \
        -e '/allowed_clients/d' \
        -e '/catch_workers_output/s/^;//' \
        -e '/error_log/d' \
        -e 's/;access.log = /access.log = \/var\//' \
        -e 's/;security.limit_extensions = .php .php3 .php4 .php5 .php7/security.limit_extensions = .php .php3 .php4 .php5 .php7/' \
        -i /etc/php/7.1/fpm/pool.d/www.conf

EXPOSE 9000

ENTRYPOINT /etc/init.d/php7.1-fpm start && bash
