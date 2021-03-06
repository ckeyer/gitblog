FROM php:5.5-apache

MAINTAINER ckeyer <me@ckeyer.com>
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-mbstring=cn

COPY . /var/www/html/

RUN echo 'LoadModule rewrite_module /usr/lib/apache2/modules/mod_rewrite.so' > /etc/apache2/mods-enabled/rewrite.load \
	# && echo 'LoadModule mbstring_module /usr/lib/apache2/modules/mod_mbstring.so' > /etc/apache2/mods-enabled/mbstring.load \
	&& chmod -R 755 ./* \
	&& mv blog /blog && ln -s /blog blog
