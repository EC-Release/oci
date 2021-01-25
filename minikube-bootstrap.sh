#!/bin/bash
printf "\n\n\n*** installing minikube for simulating test \n\n"
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.1/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.8.1/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
mkdir -p $HOME/.kube $HOME/.minikube
touch $KUBECONFIG
sudo minikube start --profile=minikube --vm-driver=none --kubernetes-version=v1.18.1
minikube update-context --profile=minikube
sudo chown -R travis: $HOME/.minikube
eval "$(minikube docker-env --profile=minikube)" && export DOCKER_CLI='docker'
kubectl create -f k8s/example/default-serviceaccount.yaml
