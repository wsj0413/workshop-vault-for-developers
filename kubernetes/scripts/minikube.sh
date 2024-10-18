#!/bin/bash

set -e -o pipefail

minikube start --driver=docker
#minikube start --driver=docker --extra-config=kubeadm.ignore-preflight-errors=NumCPU --force --cpus=1


eval $(minikube -p minikube docker-env)
cd ../payments-database && docker build -t payments-database .
cd ../payments-processor && docker build -t payments-processor .
cd ../payments-app/java && docker build -t payments-app:java .
