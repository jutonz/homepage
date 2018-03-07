#/bin/bash

set +e

echo "building $SERVICE"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG

if dctl k8s is-outdated $SERVICE -n homepage -q; then
  dctl pull $SERVICE --version=latest || true
  dctl build $SERVICE --cache-from=`dctl tag-for $SERVICE --version=latest`
  docker tag `dctl tag-for $SERVICE` `dctl tag-for $SERVICE --version=latest`
else
  echo "$SERVICE would not be updated by build"
fi

rm -f $KUBECONFIG
