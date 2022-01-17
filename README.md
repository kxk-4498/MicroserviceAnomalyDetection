# Microservice Anomaly Detection
Brian: I want this repository to become the central repository for all things microservice related.
It is a mess and we need to cleanup the whole repository

## Deploying SockShop
1. Install minikube
2. Start minikube: `minikube start`
3. Deploy SockShop: `kubectl apply -f ./sockshop_modified_full_cluster.yaml`

## Simulating Traffic on SockShop
1. cd into `experiment_coordinator`
2. Setup a conda environment: `conda env create -f environment.yml`
3. Cd into `traffic_simulation`
If you need to populate the database full of users: `python pop_db.py`
4. Simulate traffic: `simulate_traffic.py`

## Collecting Data with Cilium
Look at `cilium-readme.md` but note it assumes we are on cloudlab (we no longer user cloudlab)

We should redo the tutorial by looking at: https://docs.cilium.io/en/stable/gettingstarted/

## Todo
1. Cleanup Repository
2. Fix Cilium data collection
3. Run data exfiltration attack