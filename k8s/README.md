## EC Connectivity in kubernetes
agent k8s deployment via helmchart examples

### requirement
- [helm 3.0+](https://helm.sh/docs/intro/install/)
- [kubectl 1.10+](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### chart usage
```bash
# bootstrap a chart
$ helm create mychart

# optional add the following agent package(s) to a helm charts deployment
$ helm repo add agent https://enterprise-connect.github.io/oci/k8s/agent
$ helm repo add agent+vln https://enterprise-connect.github.io/oci/k8s/agent+vln
$ helm repo add agent+tls https://enterprise-connect.github.io/oci/k8s/agent+tls

$ helm repo list
agent    https://enterprise-connect.github.io/oci/k8s/agent

```

```yaml
# add chart dependencies to mychart/Chart.yaml
dependencies:
- name: agent
  version: 0.1.0
  repository: @agent
#optional
- name: agent+vln
  version: 0.1.0
  repository: @agent+vln
...
```

```bash
# update chart repo index
$ helm dependency update mychart

# test charts template
$ helm template mychart

# deploy charts
$ helm install --set ec-config=</path/to/conf.yaml> --<debug|dry-run> mychart mychart/
```

### chart developer

### use case I
The diagram illustrates the usage of the connectivity model in k8s
![LB Seq. High Level](/doc/k8s-ftp.png)
