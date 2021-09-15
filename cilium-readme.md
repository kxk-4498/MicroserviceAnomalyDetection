# Setting up Cilium with Kubernetes + sock shop

This quick README was written by Clement Fung, for the 18731 Network Security class, Spring 2021.

## Assumptions

This guide assumes that you have already followed the main instructions in the main README, at least up to running 
`bash deploy_sockshop.sh`. This guide also assumes that Cilium was properly instead using `bash deploy_kubespray.sh -c`. If the `-c` flag was missed, just execute the missing section of the setup. You don't need to start again from scratch.

Run the following commands:
1. `kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.9.5/install/kubernetes/quick-install.yaml`
2. `export CILIUM_NAMESPACE=kube-system`
3. `kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.9.5/install/kubernetes/quick-hubble-install.yaml`

## Using Cilium

1. Check that Cilium is actually installed and running: `kubectl -n kube-system get pods`.  
You should see pods with the names `cilium-XXXX` and their status should be `RUNNING`.  
For the rest of this guide, I'll assume `cilium-m2ktf` is the name of the Cilium pod.

2. You should also check that Hubble is successfully running inside these pods.  
Using any of the cilium pods, run: `kubectl -n kube-system exec cilium-m2ktf -- hubble status`

> In case the above command is unclear, `kubectl exec` allows you to run a command (whatever follows `--`) from within a kubernetes container. In this case, we just want to check that hubble is set up properly.

You should see `Healthcheck: Ok` in the output.

3. Next, we need to setup Hubble Relay to aggregate the flows. 
Open a separate window in Cloudlab and run `kubectl -n kube-system port-forward service/hubble-relay --address 0.0.0.0 --address :: 4245:80`. 
This forwards traffic from port 80 of the relay service to the node you are connected to on port 4245, allowing you to observer the traffic from all the cilium pods. 

4. You need to download the hubble utility from Github to access use the hubble relay service on port 4245 from the local machine. Use `curl -JLO https://github.com/cilium/hubble/releases/download/v0.8.2/hubble-linux-amd64.tar.gz` to fetch the tarball and `curl -JLO https://github.com/cilium/hubble/releases/download/v0.8.2/hubble-linux-amd64.tar.gz.sha256sum` to get the sha256sum for the tarball.

5. Verify the sha256sum of the tarball and value in the sha256sum file using `sha256sum hubble-linux-amd64.tar.gz -c hubble-linux-amd64.tar.gz.sha256sum`. If verified OK, extract the tarball using `tar -xvzf hubble-linux-amd64.tar.gz`.

6. Check the health of the hubble relay: `./hubble status --server localhost:4245`
You should see `Healthcheck (via localhost:4245): Ok` in the output. 
Whenever you want to use the relay in the future, you need to specify `--server localhost:4245` at the end of any `hubble` command.

7. Collect flows! To collect the flow from a specific cilium pod use: `kubectl -n kube-system exec cilium-m2ktf -- hubble observe --server localhost:4245 --follow`.
If you want to collect the flow from all the cilium nodes you can leverage the hubble relay service by using `./hubble observe --server localhost:4245 --follow`.
Pipe this output into a file to save the results. You may want to specify other options, such as `-o json` when running `hubble observe`. See `hubble observe --help` for your options.

8. Run whatever workload you like, perform attacks, etc. If all is well, Hubble will capture it.
