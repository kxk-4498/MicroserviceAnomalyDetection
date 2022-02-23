#Provide pod_id as argument to p to enable L7 data collection for cilium pod.
pod_id_to_enable_http_collection=''
while getopts 'p:' flag; do
	case "${flag}" in
		p) pod_id_to_enable_http_collection="${OPTARG}";;
	esac
done

kubectl annotate pod $pod_id_to_enable_http_collection -n sock-shop io.cilium.proxy-visibility="<Egress/53/UDP/DNS>,<Egress/8079/TCP/HTTP>,<Ingress/8079/TCP/HTTP>" 
