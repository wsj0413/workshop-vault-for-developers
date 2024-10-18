#!/bin/bash

set -e -o pipefail

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

minikube start --driver=docker
#minikube start --driver=docker --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus=1


eval $(minikube -p minikube docker-env)
cd ../payments-database && docker build -t payments-database .
cd ../payments-processor && docker build -t payments-processor .
cd ../payments-app/java && docker build -t payments-app:java .
