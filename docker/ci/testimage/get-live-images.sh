#/bin/bash

set -e

service="app"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG

dctl tag-for $service
dctl k8s live-image $service -n homepage

dctl k8s is-outdated $service -n homepage
echo $?

if dctl k8s is-outdated $service -n homepage; then
  echo "$service is outdated"
else
  echo "$service is not outdated"
fi

rm -f $KUBECONFIG
