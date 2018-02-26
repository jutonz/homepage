set -ex

chmod 700 /var/lib/postgresql/data

sudo -u postgres /usr/lib/postgresql/10/bin/postgres --config-file=/etc/postgresql/10/main/postgresql.conf
