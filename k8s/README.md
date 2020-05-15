## agent k8s deployment via helmchart examples
### Add Agent Charts to your Helm Repo
```bash
# optional add the following mode(s) to a helm charts deployment package
$ helm repo add ec-client https://enterprise-connect.github.io/oci/k8s/client
$ helm repo add ec-server https://enterprise-connect.github.io/oci/k8s/server
$ helm repo add ec-gateway https://enterprise-connect.github.io/oci/k8s/gateway
$ helm repo add ec-vln https://enterprise-connect.github.io/oci/k8s/vln
$ helm repo add ec-xgateway https://enterprise-connect.github.io/oci/k8s/xgateway
$ helm repo add ec-xserver https://enterprise-connect.github.io/oci/k8s/xserver
$ helm repo add ec-xclient https://enterprise-connect.github.io/oci/k8s/xclient

$ helm repo list
ec-client    https://enterprise-connect.github.io/oci/k8s/client
```

### Agent Helm Chart usage example

### use case I
The diagram illustrates the usage of the connectivity model in k8s
![LB Seq. High Level](/doc/k8s-ftp.png)
