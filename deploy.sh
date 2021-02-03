#!/bin/bash

echo 'start install'
minikube addons enable ingress
kubectl apply \
    -f ./rabbitmq/ \
    -f ./message-dashboard/ \
    -f ./message-service/ \
    -f ./monitoring/ \
    -f ./trigger-service/ \
    -f ./shared/
echo 'end install'
