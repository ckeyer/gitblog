FROM php:5.5-apache

MAINTAINER ckeyer <me@ckeyer.com>

COPY . /var/www/html/

RUN echo 'LoadModule rewrite_module /usr/lib/apache2/modules/mod_rewrite.so' > /etc/apache2/mods-enabled/rewrite.load \
	&& mkdir -p app/cache 
	# && mv blog /blog && ln -s /blog blog
