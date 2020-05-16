## agent k8s deployment via helmchart examples
### Step One add Agent Charts to your Helm Repo
```bash
# optional add the following agent package(s) to a helm charts deployment
$ helm repo add agent https://enterprise-connect.github.io/oci/k8s/agent
$ helm repo add agent+vln https://enterprise-connect.github.io/oci/k8s/agent+vln
$ helm repo add agent+tls https://enterprise-connect.github.io/oci/k8s/agent+tls

$ helm repo list
agent    https://enterprise-connect.github.io/oci/k8s/agent

# update chart repo index
$ helm dependency update <agent|agent+vln|agent+tls>

# deploy charts
$ helm install --set ec-config=</path/to/conf.yaml> <agent|agent+vln|agent+tls>
```

### Step Two the _helper usage example

### use case I
The diagram illustrates the usage of the connectivity model in k8s
![LB Seq. High Level](/doc/k8s-ftp.png)
