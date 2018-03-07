#/bin/bash

set -e

echo "pushing $SERVICE"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG

if dctl k8s is-outdated $SERVICE -n homepage; then
  docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
  dctl push $SERVICE
  docker push `dctl tag-for $SERVICE --version=latest`
else
  echo "$SERVICE would not be updated by push"
fi

rm -f $KUBECONFIG
