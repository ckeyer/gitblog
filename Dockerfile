FROM php:7.0-apache

MAINTAINER ckeyer <me@ckeyer.com>

COPY . /var/www/html/

RUN echo 'LoadModule rewrite_module /usr/lib/apache2/modules/mod_rewrite.so' > /etc/apache2/mods-enabled/rewrite.load
	&& echo 'RewriteEngine on' >> ./.htaccess \
	&& echo 'RewriteCond %{REQUEST_FILENAME} !-f' >> ./.htaccess \
	&& echo 'RewriteCond %{REQUEST_FILENAME} !-d' >> ./.htaccess \
	&& echo 'RewriteCond $1 !^(index\.php|img|robots\.txt)' >> ./.htaccess \
	&& echo 'RewriteRule ^(.*)$ /index.php/$1 [L]' >> ./.htaccess \
	&& mkdir -p app/cache \
	&& mv blog /blog && ln -s /blog blog
