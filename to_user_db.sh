#!bin/sh

userdb=`kubectl get pods --namespace sock-shop | grep user-db | sed -e 's/\s.*$//'`
kubectl annotate pod "$userdb" -n sock-shop io.cilium.proxy-visibility="<Egress/53/UDP/DNS>"
kubectl exec --stdin --tty "$userdb" --namespace sock-shop -- /bin/bash
