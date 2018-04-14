#!/bin/bash

set -ex

DIR=/etc/entrypoint.d/

if [[ -d "$DIR" ]]; then
  ls -alh $DIR
  /bin/run-parts --list $DIR
  /bin/run-parts --verbose --exit-on-error $DIR
fi

exec "$@"
