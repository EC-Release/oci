#!/bin/bash

printf "\n\n\n*** install server with tls template in minikube\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled false
helm install k8s/example --set-file global.agtConfig=k8s/example/server+tls.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
kubectl rollout status deploy/$(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
sleep 2
kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
#kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses

printf "\n\n\n*** install client with local vln multi-contr template in minikube\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled false
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.remote false
helm install k8s/example --set-file global.agtConfig=k8s/example/client+vln.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
sleep 15
kubectl describe pods $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
#kubectl get pods -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.name}{", "}{end}{end}' | sort
pdn=$(kubectl get pods -o=jsonpath='{.items[0].metadata.name}')
echo pdn: $pdn
ctns=$(kubectl get pods -o=jsonpath='{range .items[*]}{range .spec.containers[*]}{.name}{" "}{end}{range .spec.initContainers[*]}{.name}{end}' | sort)
echo ctns: $ctns
for i in $ctns
do
   kubectl logs -p $pdn -c $i --since=5m
done

printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses

printf "\n\n\n*** install client with remote vln template in minikube\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled false
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.remote true
helm install k8s/example --set-file global.agtConfig=k8s/example/client+vln.env --generate-name
printf "\n\n\n*** verify logs in minikube\n\n"
kubectl get deployments && kubectl get pods && kubectl get services && kubectl get ingresses
#kubectl logs -p $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1) --since=5m
kubectl rollout status deploy/$(kubectl get deployments|grep agent-plg|awk '{print $1}'|head -n 1)
#kubectl describe deployments $(kubectl get pods|grep agent-plg|awk '{print $1}'|head -n 1)
printf "\n\n\n*** done debug go ahead delete all.\n\n"
kubectl delete --all deployments && kubectl delete --all pods && kubectl delete --all services && kubectl delete --all ingresses
