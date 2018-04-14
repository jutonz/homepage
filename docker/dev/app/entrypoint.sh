#!/bin/bash

set -ex

DIR=/etc/entrypoint.d/

if [[ -d "$DIR" ]]; then
  /bin/run-parts --verbose --exit-on-error $DIR
fi

#exec "$@"
/bin/bash -c "$@"
