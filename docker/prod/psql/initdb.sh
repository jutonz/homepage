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

# The host "psql" needs to resolve to the correct db image for this to work.
# Usually we run commands like this from the app container while compose is
# running, so docker handles DNS resolution for us. But in this case we're
# running code from the psql container itself, so we neeed to setup this
# loopback manualy. (This is not persisted across container runs.)
#echo "127.0.0.1 psql" >> /ect/hosts

MIX_ENV=prod mix local.rebar --force
MIX_ENV=prod mix compile
PGHOST=localhost MIX_ENV=prod mix ecto.create --force

service postgresql stop
