#local setup for docker for mac or docker for windows k8s built in
kubectl config use-context docker-for-desktop
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

DASHBOARD=$(kubectl get pods --all-namespaces | grep dashboard | awk ' {print $2 }')
PORT=8443
echo "k8s dashboard pod $DASHBOARD"
pkill kubectl 
kubectl port-forward $DASHBOARD $PORT:$PORT --namespace=kube-system &
open https://localhost:$PORT