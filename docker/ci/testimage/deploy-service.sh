#/bin/bash

set +e
set -x

echo "deploying $SERVICE"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG

if dctl k8s is-outdated $SERVICE -n homepage; then
  cd docker/prod/k8s
  kubectl set image deployments/$SERVICE `dctl tag-for $SERVICE` -nhomepage
  kubectl rollout status deployments/$SERVICE -nhomepage
else
  echo "$SERVICE would not be updated by deploy"
fi

rm -f $KUBECONFIG
