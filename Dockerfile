FROM php:5.6

MAINTAINER ckeyer <me@ckeyer.com>

COPY . /var/www/html/

RUN apt-get update && \
	apt-get install -y software-properties-common && \
	nginx=stable && \
	add-apt-repository ppa:nginx/$nginx && \
	apt-get update && \
	apt-get upgrade -y && \
	chmod -R 755 ./* && \
	mv blog /blog && ln -s /blog blog && \
	echo 'server {\n \
        listen       80;\n \
        server_name  jockchou.gitblog.cn;\n \
        root         /data/vhosts/jockchou.gitblog.cn;\n \
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
}' > /etc/nginx/nginx.conf