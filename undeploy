#!/bin/bash

echo 'start uninstall'
kubectl delete \
    -f ./rabbitmq/ \
    -f ./message-dashboard/ \
    -f ./message-service/ \
    -f ./monitoring/ \
    -f ./trigger-service/ \
    -f ./shared/
minikube addons disable ingress
echo 'end uninstall'
