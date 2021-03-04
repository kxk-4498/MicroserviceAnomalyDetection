Step-by-step instructions to easily deploy kubespray cluster on Cloudlab. There is also support for deploying Sockshop microservice application onto the cluster and simulating user activity.

----
# Instructions
1. Create new experiment on Cloudlab using the “small-lan” profile (3 hosts) and Wisconsin cluster.
    * Should boot up quickly (within a few minutes)
2. Run: `bash setup_kubespray_prereqs.sh`
3. Manually setup passwordless-SSH:
    1. `cd ~/.ssh/`
    2. Store your cloudlab private key in tempkey.pem: Get from https://www.cloudlab.us/ and press “Download Credentials”.
    Move the whole file up to and including the “END RSA PRIVATE KEY” line. The corresponding password will be your Cloudlab profile
    password. If it succeeded, it will output “Identity added:..."
    3. Put your Cloudlab public key in tempkey.pub (can get from https://www.cloudlab.us/ssh-keys.php’)
4. Run: `bash deploy_kubespray.sh`
5. Setup InfluxDB integration with Prometheus (this is one way to get the time series data)
6. \[If you want to deploy sockshop\]Run: `bash deploy_sockshop.sh`
