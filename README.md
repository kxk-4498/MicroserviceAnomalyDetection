# Microservice Anomaly Detection
Brian: I want this repository to become the central repository for all things microservice related.
It is a mess and we need to cleanup the whole repository

## Deploying SockShop
1. Install minikube
2. Set minikube config to have enough memory and cpu
   1. `minikube config set memory 16384`
   2. `minikube config set cpus 10`
3. Create a profile for your cluster: `minikube profile CLUSTER_NAME`
4. Start minikube: `minikube start --cni=cilium -p CLUSTER_NAME`
5. Deploy SockShop: `bash deploy_sockshop.sh`

Check status of pods: `kubectl get pods --namespace sock-shop`

Get IP of front-end service: `minikube service --profile CLUSTER_NAME --url front-end -n sock-shop` 

Test if it is working `curl http://192.168.49.2:30001` or go to link in browser

## Debugging cilium connectivity 
1. Follow the guide for first time : https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/cilium-network-policy/
2. Use https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/ to run tests : cilium connectivity test and cilium status --wait to verify outputs match.

## Simulating Traffic on SockShop
1. cd into `experiment_coordinator`
2. Setup a conda environment: `conda env create -f condaEnv.yml`
3. Cd into `traffic_simulation`
4. Activate conda env: `conda activate sockShop`
If you need to populate the database full of users: `python simulate_traffic.py -p`
4. Simulate traffic: `python simulate_traffic.py -t`

## Collecting Data with Cilium
1. `bash deploy_cilium.sh`, Brian: installs and deploys cilium, might want a better script

Documentation: https://docs.cilium.io/en/stable/gettingstarted/

## Todo
1. Cleanup Repository
2. Fix Cilium data collection
3. Run data exfiltration attack
