#local setup for docker for mac or docker for windows k8s built in
kubectl config use-context docker-for-desktop

# deploy kubernetes dashboard
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

# deploy heapster for metrics 
kubectl apply --filename https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
kubectl apply --filename https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/standalone/heapster-controller.yaml

DASHBOARD=$(kubectl get pods --all-namespaces | grep dashboard | awk ' {print $2 }')
PORT=8443
echo "k8s dashboard pod $DASHBOARD"
pkill kubectl 
kubectl port-forward $DASHBOARD $PORT:$PORT --namespace=kube-system &
open https://localhost:$PORT

deploy(){
  namespace=votingapp
  kubectl create ns $namespace

  for deploy in voting-api voting-ui 
  do
    kubectl run $deploy \
      --image=${REGISTRY}/$deploy \
      --port 80 \
      --env="REDIS=redis:6379" \
      --env="VOTING_API_PORT=80" \
      --namespace $namespace
    kubeclt expose deploy $deploy --port 80 -type=NodePort
  done
}