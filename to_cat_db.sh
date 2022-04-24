#!bin/sh

catdb=`kubectl get pods --namespace sock-shop | grep catalogue-db | sed -e 's/\s.*$//'`
kubectl annotate pod "$catdb" -n sock-shop io.cilium.proxy-visibility="<Egress/53/UDP/DNS>"

kubectl exec --stdin --tty "$catdb" --namespace sock-shop -- /bin/bash
