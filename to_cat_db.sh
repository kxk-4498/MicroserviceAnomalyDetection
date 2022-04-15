#!bin/sh

catdb=`kubectl get pods --namespace sock-shop | grep catalogue-db | sed -e 's/\s.*$//'`

kubectl exec --stdin --tty "$catdb" --namespace sock-shop -- /bin/bash
