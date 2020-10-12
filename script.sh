#!/bin/bash

yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq yq "$@"
}

kubectl cluster-info
helm version
echo $(pwd)

printf "\n\n\n*** update the pkg chart params \n\n"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent+helper/Chart.yaml"
eval "sed -i -e 's#<AGENT_CHART_REV>#${AGENT_CHART_REV}#g' k8s/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_PLG_CHART_REV>#${AGENT_PLG_CHART_REV}#g' k8s/agent+plg/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent+plg/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/example/Chart.yaml"
eval "sed -i -e 's#<AGENT_PLG_CHART_REV>#${AGENT_PLG_CHART_REV}#g' k8s/example/Chart.yaml"
eval "sed -i -e 's#<AGENT_CHART_REV>#${AGENT_CHART_REV}#g' k8s/example/Chart.yaml"
cat k8s/agent+helper/Chart.yaml k8s/agent/Chart.yaml k8s/agent+plg/Chart.yaml k8s/example/Chart.yaml

printf "\n\n\n*** packagin w/ dependencies \n\n"
mkdir -p k8s/pkg/agent/$AGENT_CHART_REV k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV
ls -la k8s/pkg
helm package k8s/agent+helper -d k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV
helm dependency update k8s/agent
helm dependency update k8s/agent+plg
helm package k8s/agent -d k8s/pkg/agent/$AGENT_CHART_REV
helm package k8s/agent+plg -d k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV

printf "update dependencies in example chart for test"
helm dependency update k8s/example  
printf "\n\n\n*** test server with tls template\n\n"
helm template k8s/example --debug --set-file global.agtConfig=k8s/example/server+tls.env
printf "\n\n\n*** test gateway agt template\n\n"
helm template k8s/example --debug --set-file global.agtConfig=k8s/example/gateway.env
printf "\n\n\n*** test client with vln template\n\n"
helm template k8s/example --debug --set-file global.agtConfig=k8s/example/client+vln.env --generate-name
  
printf "\n\n\n*** test v1 agt mode w/ docker\n\n"
docker run -it --rm --env-file=k8s/example/gateway.env enterpriseconnect/agent:v1 > agt.log || cat agt.log
printf "\n\n\n*** test v1beta agt mode w/ docker\n\n"
docker run -it --rm --env-file=k8s/example/gateway.env enterpriseconnect/agent:v1beta > agt.log || cat agt.log

printf "\n\n\n*** test server+tls v1 plugin w/ docker\n\n"
docker run -it --rm -d --name server-tls --env-file=k8s/example/server+tls.env enterpriseconnect/plugins:v1 && sleep 5 && docker logs server-tls 
printf "\n\n\n*** test client+vln v1 plugin w/ docker\n\n"
docker run -it --rm -d --name client-vln --env-file=k8s/example/client+vln.env enterpriseconnect/plugins:v1 && sleep 5 && docker logs client-vln 
  
printf "\n\n\n*** installing minikube for simulating test \n\n"
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.1/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.8.1/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
mkdir -p $HOME/.kube $HOME/.minikube
touch $KUBECONFIG
sudo minikube start --profile=minikube --vm-driver=none --kubernetes-version=v1.18.1
minikube update-context --profile=minikube
"sudo chown -R travis: /home/travis/.minikube/"
eval "$(minikube docker-env --profile=minikube)" && export DOCKER_CLI='docker'
kubectl create -f k8s/example/default-serviceaccount.yaml

printf "\n\n\n*** install server with tls template in minikube\n\n"
cat k8s/example/values.yaml
cat k8s/example/values.yaml | yq w - global.agtK8Config.withPlugins.tls.enabled true | tee k8s/example/values.yaml
cat k8s/example/values.yaml | yq w - global.agtK8Config.withPlugins.vln.enabled false | tee k8s/example/values.yaml
cat k8s/example/values.yaml
helm install k8s/example --debug --set-file global.agtConfig=k8s/example/server+tls.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses

printf "\n\n\n*** install client with vln multi-contr template in minikube\n\n"
cat k8s/example/values.yaml | yq w - global.agtK8Config.withPlugins.tls.enabled false | tee k8s/example/values.yaml
cat k8s/example/values.yaml | yq w - global.agtK8Config.withPlugins.vln.enabled true | tee k8s/example/values.yaml
cat k8s/example/values.yaml | yq w - global.agtK8Config.withPlugins.vln.remote false | tee k8s/example/values.yaml
helm install k8s/example --debug --set-file global.agtConfig=k8s/example/client+vln.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses

printf "\n\n\n*** pkg indexing\n\n"
helm repo index k8s/pkg/agent/$AGENT_CHART_REV --url https://ec-release.github.io/oci/agent/$AGENT_CHART_REV
helm repo index k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV --url https://ec-release.github.io/oci/agent+helper/$AGENT_HELPER_CHART_REV
helm repo index k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV --url https://ec-release.github.io/oci/agent+plg/$AGENT_PLG_CHART_REV
