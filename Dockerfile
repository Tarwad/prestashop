#FROM php:5.6-apache
FROM debian:jessie

MAINTAINER Sebastien Libert <sebastien.libert@skynet.be>

ENV DEBIAN_FRONTEND noninteractive

#ENV PS_VERSION 1.5.6.0

ENV GIT_REPO git@github.com:PrestaShop/PrestaShop.git
ENV GIT_BRANCH master




ENV PS_DOMAIN prestashop.local
ENV DB_SERVER 127.0.0.1
ENV DB_PORT 3306
ENV DB_NAME prestashop
ENV DB_USER root
ENV DB_PASSWD admin
ENV ADMIN_MAIL sebastien.libert@skynet.be
ENV ADMIN_PASSWD SEBAINFO
ENV PS_LANGUAGE fr
ENV PS_COUNTRY be
ENV PS_INSTALL_AUTO 1
ENV PS_DEV_MODE 0
ENV PS_HOST_MODE 0
ENV PS_HANDLE_DYNAMIC_DOMAIN 0

ENV PS_FOLDER_ADMIN gestion
ENV PS_FOLDER_INSTALL ps_install

#Installation of NGINX


MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

ENV NGINX_VERSION 1.9.12-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

# install hTOP - PHP fpm
RUN apt-get update && apt-get upgrade -y && apt-get install htop software-properties-common python-software-properties -y
RUN apt-get install php5-fpm php5-mysqlnd php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-memcached php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl fcgiwrap memcached -y

# install Pureftpd, bind9 et fail2ban :
RUN apt-get install pure-ftpd-common pure-ftpd-mysql bind9 dnsutils fail2ban nano -y



# Avoid MySQL questions during installation

# RUN echo mysql-server-5.6 mysql-server/root_password password $DB_PASSWD | debconf-set-selections
# RUN echo mysql-server-5.6 mysql-server/root_password_again password $DB_PASSWD | debconf-set-selections

# RUN apt-get update \
# 	&& apt-get install -y libmcrypt-dev \
# 		libjpeg62-turbo-dev \
# 		libpng12-dev \
# 		libfreetype6-dev \
# 		libxml2-dev \
# 		mysql-client \
# 		mysql-server \
# 		wget \
# 		unzip \
#     && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#     && docker-php-ext-install iconv mcrypt pdo mysql pdo_mysql mbstring soap gd

# Get PrestaShop
# ADD https://github.com/PrestaShop/PrestaShop/releases/download/1.6.1.4/prestashop_1.6.1.4.zip /tmp/prestashop.zip
# RUN unzip -q /tmp/prestashop.zip -d /tmp/ && mv /tmp/prestashop/* /var/www/html && rm /tmp/prestashop.zip
# COPY config_files/docker_updt_ps_domains.php /var/www/html/

# Apache configuration
# RUN a2enmod rewrite
# RUN chown www-data:www-data -R /var/www/html/

# PHP configuration
# COPY config_files/php.ini /usr/local/etc/php/

# MySQL configuration
# RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
# EXPOSE 3306

# VOLUME /var/www/html/modules
# VOLUME /var/www/html/themes
# VOLUME /var/www/html/override

# COPY config_files/docker_run.sh /tmp/
# ENTRYPOINT ["/tmp/docker_run.sh"]
