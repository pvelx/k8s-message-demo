#!/bin/bash

SHA=3

#minikube start --vm-driver=parallels
minikube start
minikube addons enable ingress

eval $(minikube docker-env)
docker build -t dashboard:latest -t dashboard:$SHA -f ../MessageDashboard/Dockerfile.dev ../MessageDashboard/
docker build -t server-php-fpm:latest -t server-php-fpm:$SHA -f ../MessageBackend/docker/Dockerfile ../MessageBackend/
docker build -t rabbitmq-message-demo:latest -t rabbitmq-message-demo:$SHA -f ./rabbitmq/Dockerfile ./rabbitmq
docker build -t task-service:latest -t task-service:$SHA -f ../../GolandProjects/triggerHookExample/Dockerfile ../../GolandProjects/triggerHookExample/

kubectl apply -f ./dashboard/
kubectl apply -f ./broker/
kubectl apply -f ./message-service/
kubectl apply -f ./monitoring/
kubectl apply -f ./trigger-service/
kubectl apply -f ./ingress-service.yaml
kubectl apply -f ./persistent-volume-claim.yaml
kubectl set image deployments/client-deployment client=dashboard:$SHA
