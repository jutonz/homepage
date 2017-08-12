FROM nginx:1.13

COPY docker/prod/nginx/default.conf /etc/nginx/sites-enabled/default
COPY docker/prod/nginx/nginx.conf /etc/nginx/nginx.conf

COPY docker/prod/nginx/init.sh /etc/init.sh

CMD ["/bin/bash", "-c", "/etc/init.sh"]
