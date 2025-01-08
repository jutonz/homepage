#!/bin/bash

if [ -z "${SECRET_KEY}" ]; then
  echo "SECRET_KEY is missing. Please set and try again."
  exit 1
fi

cd secrets
echo -n $SECRET_KEY > key.txt
cd -

exec "${@}"
