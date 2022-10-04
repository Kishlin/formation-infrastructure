#!/usr/bin/bash

# echo "Building, tagging, and pushing Docker image"
# docker build . -t kishlin/simple-nginx -f Services/Nginx/Dockerfile
# docker push kishlin/simple-nginx
# echo "\n\n"

echo "Starting Minikube"
minikube start

echo "\n\n\nPart One: First Cluster"

echo "\n\nCreating Nginx deployment based on the docker image, with 2 pods"
kubectl create deployment demo --image=kishlin/simple-nginx --port=80
kubectl scale deployments/demo --replicas=2

echo "\n\nNames of running pods:"
kubectl get pods --no-headers -o custom-columns=":metadata.name"
echo "Port forwarding on localhost: kubectl port-forward pods/{POD} 8080:80"


echo "\n\n\nPart Two: External Access"

# DOES NOT WORK

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/cloud/deploy.yaml
#kubectl get pods --namespace=ingress-nginx

#kubectl expose deployment demo
#kubectl create ingress nginx-localhost --class=nginx --rule="demo.localdev.me/*=demo:80"
