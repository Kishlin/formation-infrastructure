# Using Minikube & Kubectl

# Starting the cluster

```shell
minikube start
kubectl cluster-info

kubectl get events
kubectl get nodes
kubectl get pods

kubectl config view
```

# Deployment - Hello World

```shell
kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4
kubectl get deployments

kubectl expose deployment hello-node --type=LoadBalancer --port=8080
kubectl get services

minikube service hello-node
```

```shell
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
```

```shell
# Communicate with the API through shell
kubectl proxy
curl http://localhost:8001/version

# Store the POD name in a variable
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# Access the POD through the API
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/
```

# Exploring app

```shell
kubectl get # list resources
kubectl describe # show detailed information about a resource
kubectl logs # print the logs from a container in a pod
kubectl exec # execute a command on a container in a pod
```

```shell
kubectl describe pods

kubectl proxy

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
# Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-fb5c67579-rhdzm | v=1

kubectl exec $POD_NAME -- env
kubectl exec -ti $POD_NAME -- bash
```

# Public Exposition

```shell
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
kubectl get services

export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT
# NODE_PORT=31307

curl $(minikube ip):$NODE_PORT
# Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-fb5c67579-rhdzm | v=1
```

# App Scaling

```shell
kubectl get deployments
kubectl get rs # list replica sets

kubectl scale deployments/kubernetes-bootcamp --replicas=4
kubectl get deployments
kubectl get pods -o wide
# NAME                                  READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
# kubernetes-bootcamp-fb5c67579-72glc   1/1     Running   0          12s     172.18.0.9   minikube   <none>           <none>
# kubernetes-bootcamp-fb5c67579-8l8jj   1/1     Running   0          12s     172.18.0.7   minikube   <none>           <none>
# kubernetes-bootcamp-fb5c67579-9dwhc   1/1     Running   0          2m17s   172.18.0.5   minikube   <none>           <none>
# kubernetes-bootcamp-fb5c67579-tcj29   1/1     Running   0          12s     172.18.0.8   minikube   <none>           <none>

kubectl describe deployments/kubernetes-bootcamp

kubectl describe services/kubernetes-bootcamp
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT
# NODE_PORT=31679
curl $(minikube ip):$NODE_PORT # every request hits a different pod

kubectl scale deployments/kubernetes-bootcamp --replicas=2
kubectl get deployments
kubectl get pods -o wide # 2 pods were terminated
```

# Rolling Updates

```shell
kubectl get deployments
kubectl get pods
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
kubectl get pods # New pods with the new version

kubectl describe services/kubernetes-bootcamp
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT
curl $(minikube ip):$NODE_PORT # Now states v2

kubectl rollout status deployments/kubernetes-bootcamp
kubectl describe pods # Image now states v2
```

# Rollback

```shell
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v10 # Fails
kubectl get deployments
kubectl get pods # Some are failed
kubectl describe pods # Error appears in Events

kubectl rollout undo deployments/kubernetes-bootcamp
kubectl get pods
```
