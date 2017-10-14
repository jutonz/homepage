set -x
set -e

chown -Rf postgres:postgres /var/lib/postgresql/data
chmod -R 700 /var/lib/postgresql/data

su - postgres -c "/usr/lib/postgresql/10/bin/initdb -D /var/lib/postgresql/data/ --encoding=utf8"

chown -Rf postgres:postgres /var/lib/postgresql/data
chmod -R 700 /var/lib/postgresql/data

service postgresql start
sudo -u postgres psql -c "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';"

cd /tmp/code

MIX_ENV=prod mix local.rebar --force
MIX_ENV=prod mix compile
PGHOST=localhost MIX_ENV=prod mix ecto.create --force
PGHOST=localhost MIX_ENV=prod mix ecto.migrate --force

service postgresql stop
