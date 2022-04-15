#!bin/sh

front=`kubectl get pods --namespace sock-shop | grep front-end | sed -e 's/\s.*$//'`

kubectl exec --namespace sock-shop -it "$front" -- /bin/sh
