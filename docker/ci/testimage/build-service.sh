#/bin/bash

set +e

service=$1

if [ -z "$service" ]; then
  echo "usage: ./build-service.sh [SERVICE]"
  exit 1
fi

echo "building $service"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG

if dctl k8s is-outdated $service -n homepage -q; then
  dctl pull $service --version=latest || true
  dctl build $service --cache-from=`dctl tag-for $service --version=latest`
  docker tag `dctl tag-for $service` `dctl tag-for $service --version=latest`
else
  echo "$service would not be updated by build"
fi

rm -f $KUBECONFIG
