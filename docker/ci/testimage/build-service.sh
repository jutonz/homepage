#/bin/bash

set -e

service=$1

if [ -z "$service" ]; then
  echo "usage: ./build-service.sh [SERVICE]"
  exit 1
fi

echo "building $service"

dctl pull $service --version=latest || true
dctl build $service --cache-from=`dctl tag-for $service --version=latest`
docker tag `dctl tag-for $service` `dctl tag-for $service --version=latest`
