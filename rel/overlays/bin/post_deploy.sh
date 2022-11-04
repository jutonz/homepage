#!/bin/bash

# This runs on the server OS after a release has been finsished, but before
# the new server starts. You can run migrations and whatnot here.

set -ex

./bin/homepage eval "Client.Release.migrate()"
./bin/homepage eval "Twitch.Release.migrate()"

sudo cp /etc/letsencrypt/live/jutonz.com/fullchain.pem /home/jutonz/srv/homepage/secrets/fullchain.pem
sudo cp /etc/letsencrypt/live/jutonz.com/privkey.pem /home/jutonz/srv/homepage/secrets/privkey.pem
#sudo chown jutonz:jutonz /home/jutonz/srv/homepage/secrets/*pem
# TODO: chown SSL certificates

sudo systemctl start homepage
