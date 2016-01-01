FROM php:5.6-fpm

MAINTAINER ckeyer <me@ckeyer.com>

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.9-1~jessie

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN echo 'server {\n \
        listen       80 default;\n \
        root         /var/www/html/;\n \
        index        index.html index.htm index.php;\n \
\n \
        location ~ \\.(jpg|png|gif|js|css|swf|flv|ico)$ {\n \
                 expires 12h;\n \
        }\n \
\n \
        location / {\n \
                if (!-e $request_filename) {\n \
                    rewrite ^(.*)$ /index.php?$1 last ;\n \
                    break;\n \
                }\n \
        }\n \
\n \
        location ~* ^/(doc|logs|app|sys)/ {\n \
                return 403;\n \
        }\n \
\n \
        location ~ .*\\.(php|php5)?$\n \
        {\n \
                fastcgi_connect_timeout 300;\n \
                fastcgi_send_timeout 300;\n \
                fastcgi_read_timeout 300;\n \
                fastcgi_pass   127.0.0.1:9000;\n \
                fastcgi_index  index.php;\n \
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;\n \
                include        fastcgi_params;\n \
        }\n \
}' > /etc/nginx/conf.d/default.conf

COPY . /var/www/html/
RUN chmod -R 755 ./* && \
	mv blog /blog && ln -s /blog blog
WORKDIR /var/www/html/
EXPOSE 80 443 9000
ENTRYPOINT ["nginx", "-g", "daemon off;"]
ENTRYPOINT php-fpm
