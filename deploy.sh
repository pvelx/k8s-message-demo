#!/bin/bash

SHA=3

minikube start --vm-driver=parallels
#minikube start
minikube addons enable ingress

eval $(minikube docker-env)
docker build -t message-dashboard:latest -t message-dashboard:$SHA -f ../message-dashboard-demo/Dockerfile.dev ../message-dashboard-demo/
docker build -t message-service:latest -t message-service:$SHA -f ../message-service-demo/docker/Dockerfile ../message-service-demo/
docker build -t rabbitmq-message:latest -t rabbitmq-message:$SHA -f ./rabbitmq/Dockerfile ./rabbitmq
docker build -t trigger-service:latest -t trigger-service:$SHA -f ../trigger-service-demo/Dockerfile ../trigger-service-demo/

kubectl apply -f ./rabbitmq/
kubectl apply -f ./message-dashboard/
kubectl apply -f ./message-service/
kubectl apply -f ./monitoring/
kubectl apply -f ./trigger-service/
kubectl apply -f ./ingress-service.yaml
kubectl apply -f ./persistent-volume-claim.yaml
kubectl set image deployments/client-deployment client=dashboard:$SHA
