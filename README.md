# terraform-kubernetes

## Introduction
This configuration utilizes HCL (HashiCorp Configuration Language) terraform to build a kubernetes cluster using KinD (Kubernetes in Docker) and to deploy applications (pods) on top of it

## Files Content
1. **cluster.tf**: Holds the main configuration of our kubernetes cluster using KinD.
2.  **providers.tf**: Holds names and version of Terraform plugins used in the project with initial construction of configuration.
3.  **Deploy.tf**: Holds configuration of software to be deployed on our KinD cluster.
4.  **inngress-nginx**: Holds configuration for deploying ingress on our KinD cluster for 1 or more software to be exposed externally.


## Setup and deploy KinD cluster

First make sure you have terraform installed  [official site](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and docker [here](https://docs.docker.com/engine/install/).

then go to our directory and run

```hcl
terraform init
```
To initialize our plugins and download them, Then

```hcl
terraform plan
terraform apply -auto-approve
```

last we need to deploy our ingress service to the cluster, run:

```shell
kubectl apply -f ingress-nginx.yaml
```

to verify our ingress is deployed successfully you can run:
```
kubectl get -n ingress-nginx pod
```

to find output of 3 pods 2 in completed state and the ingress controller should be running.

## verify and access our services
if you look in the Deploy file you see we deployed 3 services (Jenkins,prometheus and grafana)

Jenkins, we deployed and exposed it as `ClusterIP` and mirrored it to localhost using our ingress which we deployed earlier.
so to check if Jenkins is up and running successfully you can visit http://localhost

as for grafana and prometheus they are deployed and exposed  using `NodePort` so in order to access them you need to get node internal IP, run:
```
kubectl get nodes -o wide
```
then get the port they are forwareded to, run:
```
kubectl get pod -n devops -o wide
```
then you can access it using `http://[node-IP]:[forwarded-port]` for example http://172.18.0.2:32000

## Conclusion
The requirements are fulfilled now we used terraform to deploy:
1. kubernetes cluster
2. Deployment enginer (jenkins).
3. ingress
4. metrics stack (grafana + prometheus).
