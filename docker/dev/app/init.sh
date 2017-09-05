#!/bin/bash

cd /root

rm -r assets/node_modules

ln -s /tmp/code/assets/node_modules assets/node_modules

iex -S mix phx.server
