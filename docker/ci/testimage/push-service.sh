#/bin/bash

set -e

service=$1

if [ -z "$service" ]; then
  echo "usage: ./push-service.sh [SERVICE]"
  exit 1
fi

echo "pushing $service"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG

if dctl k8s is-outdated $service -n homepage -q; then
  docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
  dctl push $service
  docker push `dctl tag-for $service --version=latest`
else
  echo "$service would not be updated by push"
fi

rm -f $KUBECONFIG
