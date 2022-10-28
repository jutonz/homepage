#!/bin/bash

set -ex

export EARTHLY_BUILDKIT_HOST=tcp://littlebox.local:8372

rm -rf tmp/deploy
earthly +build

# copy binary back to littlebox
# restart server on littlebox?
#   first need to actually have server running lol
#   secrets?

