#!/bin/bash

set -ex

DIR=/etc/entrypoint.d/

if [[ -d "$DIR" ]]; then
  echo $CI
  /bin/run-parts --verbose --exit-on-error $DIR
fi

exec "$@"
