# Setting up Cilium with Kubernetes + sock shop

This quick README was written by Clement Fung, for the 18731 Network Security class, Spring 2021.

## Assumptions

This guide assumes that you have already followed the main instructions in the main README, at least up to running 
`bash deploy_sockshop.sh`. This guide also assumes that Cilium was properly installed using `bash deploy_kubespray.sh -c`. If the `-c` flag was missed, just execute the missing section of the setup. You don't need to start again from scratch.

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
This forwards traffic from port 80 to the relay service, allowing all cilium pods to access a central relay service. 

4. Check the health of the hubble relay: `kubectl -n kube-system exec cilium-m2ktf -- hubble status --server localhost:4245`
You should see `Healthcheck (via localhost:4245): Ok` in the output. 
Whenever you want to use the relay in the future, you need to specify `--server localhost:4245` at the end of any `hubble` command.

5. Collect flows! The most reliable way that I have done this is by running hubble as a monitor: `kubectl -n kube-system exec cilium-m2ktf -- hubble observe --server localhost:4245 --follow`. Pipe this output into a file to save the results.  
You may want to specify other options, such as `-o json` when running `hubble observe`. See `hubble observe --help` for your options.

6. Run whatever workload you like, perform attacks, etc. If all is well, Hubble will capture it.
