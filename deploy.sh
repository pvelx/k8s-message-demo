#!/bin/bash

SHA=3

minikube start
minikube addons enable ingress

eval $(minikube docker-env)
docker build -t dashboard:latest -t dashboard:$SHA -f ../MessageDashboard/Dockerfile.dev ../MessageDashboard/
docker build -t server-php-fpm:latest -t server-php-fpm:$SHA -f ../MessageBackend/docker/php-fpm/Dockerfile.k8s ../MessageBackend/
docker build -t rabbitmq-message-demo:latest -t rabbitmq-message-demo:$SHA -f ./rabbitmq/Dockerfile ./rabbitmq
docker build -t task-service:latest -t task-service:$SHA -f ../../GolandProjects/triggerHookExample/Dockerfile ../../GolandProjects/triggerHookExample/

kubectl apply -f ./ingress-service.yaml
kubectl apply -f ./dashboard/
kubectl set image deployments/client-deployment client=dashboard:$SHA
