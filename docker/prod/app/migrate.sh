set -e

cd /root/code

cd apps/client
MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate
cd -

cd apps/twitch
MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate
cd -
