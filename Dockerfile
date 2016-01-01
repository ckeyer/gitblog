FROM php:5.6

MAINTAINER ckeyer <me@ckeyer.com>

COPY . /var/www/html/

RUN apt-get update && \
	apt-get install -y software-properties-common && \
	nginx=stable && \
	add-apt-repository ppa:nginx/$nginx && \
	apt-get update && \
	apt-get upgrade -y && \
	&& chmod -R 755 ./* \
	&& mv blog /blog && ln -s /blog blog \
	&& echo 'server {\
        listen       80;\
        server_name  jockchou.gitblog.cn;\
        root         /data/vhosts/jockchou.gitblog.cn;\
        index        index.html index.htm index.php;\
\
        location ~ \\.(jpg|png|gif|js|css|swf|flv|ico)$ {\
                 expires 12h;\
        }\
\
        location / {\
                if (!-e $request_filename) {\
                    rewrite ^(.*)$ /index.php?$1 last ;\
                    break;\
                }\
        }\
\
        location ~* ^/(doc|logs|app|sys)/ {\
                return 403;\
        }\
\
        location ~ .*\\.(php|php5)?$\
        {\
                fastcgi_connect_timeout 300;\
                fastcgi_send_timeout 300;\
                fastcgi_read_timeout 300;\
                fastcgi_pass   127.0.0.1:9000;\
                fastcgi_index  index.php;\
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;\
                include        fastcgi_params;\
        }\
}' > /etc/nginx/nginx.conf