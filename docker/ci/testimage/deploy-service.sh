#/bin/bash

set -e

service=$1

if [ -z "$service" ]; then
  echo "usage: ./deploy-service.sh [SERVICE]"
  exit 1
fi

echo "deploying $service"

echo $KUBELET_CONF | base64 -d > $KUBECONFIG
cd docker/prod/k8s
kubectl set image deployments/$service `dctl tag-for $service` -nhomepage
kubectl rollout status deployments/$service -nhomepage
rm -f $KUBECONFIG
