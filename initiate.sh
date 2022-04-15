#!/bin/sh
minikube start --network-plugin=cni -p cryptk8s
bash deploy_sockshop.sh
bash install_cilium.sh
