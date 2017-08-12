set -x
set -e

sudo -u postgres /usr/lib/postgresql/9.6/bin/postgres --config-file=/etc/postgresql/9.6/main/postgresql.conf
