#!/bin/bash
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
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled false
helm install k8s/example --debug --set-file global.agtConfig=k8s/example/server+tls.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses

printf "\n\n\n*** install client with local vln multi-contr template in minikube\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled false
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.remote false
helm install k8s/example --debug --set-file global.agtConfig=k8s/example/client+vln.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses

printf "\n\n\n*** install client with remote vln template in minikube\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled false
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.remote true
helm install k8s/example --debug --set-file global.agtConfig=k8s/example/client+vln.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses
