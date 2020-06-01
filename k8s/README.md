## EC Connectivity in kubernetes
agent k8s deployment via helmchart examples

### Use Case PoC
The diagram illustrates the usage of the connectivity model in k8s
![LB Seq. High Level](/doc/k8s-ftp.png)

### Requirement
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
  repository: "@agent+helper"
# OPTIONAL
- name: agent
  version: 0.1.0
  repository: "@agent"
# OPTIONAL
- name: agent+vln
  version: 0.1.0
  repository: "@agent+vln"
...
```
```bash
# update chart repo index after modify the list
$ helm dependency update mychart
```
#### Agent/Chart Configuration Conversion
```bash
# convert the ec config file into a chart-readable format and be ready for the chart deployment
$ cd <path/to/mychart> && bash <(curl -s https://enterprise-connect.github.io/oci/k8s/conf.txt) \
-cfg <conf.yaml> \
-out <conf.env>
```
```batch
:: for windows 10+
c:\> cd <path\to\mychart> ^
&& curl -LOk https://github.com/Enterprise-connect/sdk/raw/v1.1beta/dist/agent/agent_windows_sys.exe.tar.gz ^
&& tar xvf agent_windows_sys.exe.tar.gz ^
&& agent_windows_sys.exe -cfg -cfg <conf.yaml> -out <conf.toml>
```
#### Install Plugin & Go
```bash
# test charts template
$ helm template mychart

# deploy charts. agtConfig must present for the custom file -out
$ helm install --set agtConfig=<conf.toml> --<debug|dry-run> mychart mychart/
install.go:158: [debug] Original chart version: ""
install.go:175: [debug] CHART PATH: /home/ayasuda/Documents/hokkaido/sdk/oci/k8s/agent

NAME: mydemo
LAST DEPLOYED: Sat May 16 20:25:44 2020
NAMESPACE: default
STATUS: pending-install
REVISION: 1
USER-SUPPLIED VALUES:
{}

COMPUTED VALUES:
affinity: {}
agent+helper:
  global: {}
fullnameOverride: ""
image:
  pullPolicy: Always
  repository: enterpriseconnect/agent:v1.1beta
imagePullSecrets: []
ingress:
  annotations: {}
  enabled: false
  hosts:
  - host: chart-example.local
    paths: []
  tls: []
nameOverride: ""
nodeSelector: {}
podSecurityContext: {}
replicaCount: 1
resources: {}
securityContext: {}
service:
  port: 80
  type: ClusterIP
serviceAccount:
  annotations: {}
  create: true
  name: miinikube
tolerations: []

HOOKS:
---
# Source: agent/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "mydemo-agent-test-connection"
  labels:
    helm.sh/chart: agent-0.1.0
    app.kubernetes.io/name: agent
    app.kubernetes.io/instance: mydemo
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test-success
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['mydemo-agent:80']
  restartPolicy: Never
MANIFEST:
---
# Source: agent/templates/configmap.yaml
apiVersion: v1
data:
  myvalue: Hello World
kind: ConfigMap
metadata:
  name: agent-mydemo
...
```

### chart developer

### Disclaimer
<sup>Helm, Charts, and its subsidiary components are the trademark of, all right reserved by Cloud Native Compute Foundation, a Linux Foundation. Examples, plugins, chart/library packages in the sub-path of this repo are actively contributed and maintained by EC R&D team. The open source software in this subpath is licensed under [CC-By-4.0](https://creativecommons.org/licenses/by/4.0/) The software is not garanteed in a working state given any environements, ownership, and the usage may change from time-to-time depend on the project priority.</sup>
