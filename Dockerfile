FROM ubuntu:trusty
MAINTAINER Tim de Jong <i@timdj.nl>

# Install packages
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get -y install git apache2 libapache2-mod-php5 php5-mysql php5-mcrypt php5-gd php5-curl php5-imagick php5-memcached

#enable opcache
RUN echo "\nopcache.enable_cli = 1\n" >> /etc/php5/apache2/conf.d/05-opcache.ini
#opcache.max_accelerated_files = 8000
#opcache.memory_consumption = 64


#  Quiet
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# config to apache
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite headers
RUN a2dismod autoindex cgi

# Configure /app folder with sample app
# RUN git clone https://github.com/fermayo/hello-world-lamp.git /app
# RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 64M
ENV PHP_POST_MAX_SIZE 64M
ENV PHP_MEMORY_LIMIT 256M

# Add volumes for Apache log
VOLUME  ["/var/log/apache"]

# Add volumes for Website
VOLUME  ["/var/www/html" ]

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
