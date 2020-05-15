## agent k8s deployment via helmchart examples
### Add Agent Charts to your Helm Repo
```bash
$ helm repo add ec-client https://enterprise-connect.github.io/oci/k8s/client
$ helm repo list
ec-client    https://enterprise-connect.github.io/oci/k8s/client
```

### Agent Helm Chart usage example

### use case I
The diagram illustrates the usage of the connectivity model in k8s
![LB Seq. High Level](/doc/k8s-ftp.png)
