#!bin/sh

front=`kubectl get pods --namespace sock-shop | grep front-end | sed -e 's/\s.*$//'`
kubectl annotate pod "$front" -n sock-shop io.cilium.proxy-visibility="<Egress/53/UDP/DNS>,<Ingress/53/UDP/DNS>"
kubectl exec --namespace sock-shop -it "$front" -- /bin/sh
