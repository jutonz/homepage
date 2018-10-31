set -e

cd /root/code

cd apps/client
MIX_ENV=prod mix run ecto.create, ecto.migrate
cd -

cd apps/twitch
MIX_ENV=prod mix run ecto.create, ecto.migrate
cd -
