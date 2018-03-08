#/bin/bash

set +e

echo "deploying $SERVICE"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG
set -x

if dctl k8s is-outdated $SERVICE -n homepage; then
  tag=`dctl tag-for $SERVICE`
  kubectl set image deployments/$SERVICE app=$tag -nhomepage
  kubectl rollout status deployments/$SERVICE -nhomepage
else
  echo "$SERVICE would not be updated by deploy"
fi

rm -f $KUBECONFIG
