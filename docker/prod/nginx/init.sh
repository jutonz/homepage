set -x
set -e

touch /var/log/nginx/homepage.access.log

service nginx start

tail -f /var/log/nginx/homepage.error.log
