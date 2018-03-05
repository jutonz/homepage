#/bin/bash

set -e

service=$1

if [ -z "$service" ]; then
  echo "usage: ./push-service.sh [SERVICE]"
  exit 1
fi

echo "pushing $service"

docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
dctl push $service
docker push `dctl tag-for $service --version=latest`
