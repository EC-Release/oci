## EC Connectivity in kubernetes
agent k8s deployment via helmchart examples

### requirement
- [helm 3.0+](https://helm.sh/docs/intro/install/)
- [kubectl 1.10+](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Getting Started

#### Add Dependency Repo
```bash
# bootstrap a chart
$ helm create mychart

# REQUIRED: add the helper library as the dependency to support usage
$ helm repo add agent+helper https://enterprise-connect.github.io/oci/k8s/pkg/agent+helper/

# OPTIONAL: add any of the following agent package(s) to the mychart deployment
# agent: the deployment includes the agent artifact, and the configuration
$ helm repo add agent https://enterprise-connect.github.io/oci/k8s/pkg/agent/
# agent+vln: agent with vlan usage, this allow the vln 
# plugin to control the vlan setting inside the container.
$ helm repo add agent+vln https://enterprise-connect.github.io/oci/k8s/pkg/agent+vln/
# agent+tls: agent with tls usage. tls can be served as a reversed-proxy to
# bypass a tls security restriction.
$ helm repo add agent+tls https://enterprise-connect.github.io/oci/k8s/pkg/agent+tls/

$ helm repo list
NAME         URL
agent+helper https://enterprise-connect.github.io/oci/k8s/pkg/agent+helper
agent        https://enterprise-connect.github.io/oci/k8s/pkg/agent

```
#### Update Dependency List
```yaml
# add chart dependencies to mychart/Chart.yaml
dependencies:
# REQUIRED
- name: agent+helper
  version: 0.1.0
  repository: @agent
# OPTIONAL
- name: agent
  version: 0.1.0
  repository: @agent
# OPTIONAL
- name: agent+vln
  version: 0.1.0
  repository: @agent+vln
...
```
#### Install Plugin & Go
```bash
# update chart repo index
$ helm dependency update mychart

# install EC helm plugin
$ helm plugin install https://enterprise-connect.github.io/oci/k8s/plg/ecagt

# generate ec configuration ready for the chart deployment
$ helm ecagt -cfg <EC configuration yaml. E.g. conf.yaml>

# test charts template
$ helm template mychart

# deploy charts
$ helm install --<debug|dry-run> mychart mychart/
```

### chart developer

### use case I
The diagram illustrates the usage of the connectivity model in k8s
![LB Seq. High Level](/doc/k8s-ftp.png)

### disclaimer
<sup>Helm, Charts, and its subsidiary components are the trademark of, all right reserved by Cloud Native Compute Foundation, a Linux Foundation. Examples, plugins, chart/library packages in the sub-path of this repo are actively contributed and maintained by EC R&D team. The open source software in this subpath is licensed under [CC-By-4.0](https://creativecommons.org/licenses/by/4.0/) The software is not garanteed in a working state given any environements, ownership, and the usage may change from time-to-time depend on the project priority.</sup>
