#!/bin/bash

service=$1
eval $(minikube docker-env)

deleteOldImages(){
  docker rmi $(docker images "$service" --format "{{.ID}}")
}

newVersion() {
  currentVersion=$(docker images "$service" --format "{{.Tag}}" | sort -rn | head -n 1)
  currentVersion="$((currentVersion + 1))"
  if [ "$currentVersion" -gt "255" ]
  then
    currentVersion=1
  fi

  return "$currentVersion"
}

case $service in
message-dashboard)
  deleteOldImages
  newVersion
  version=$?
  docker build \
    -t message-dashboard:latest \
    -t message-dashboard:$version \
    -f ../message-dashboard-demo/Dockerfile \
    ../message-dashboard-demo/
  kubectl apply -f ./message-dashboard/
  kubectl set image deployments/message-dashboard-deployment message-dashboard=message-dashboard:$version
  ;;

message-service)
  deleteOldImages
  newVersion
  version=$?
  docker build \
    -t message-service:latest \
    -t message-service:$version \
    -f ../message-service-demo/docker/Dockerfile \
    ../message-service-demo/
  kubectl apply -f ./message-service/
  kubectl set image deployments/message-service-deployment message-service=message-service:$version
  kubectl set image deployments/message-service-daemon-deployment message-service-daemon=message-service:$version
  ;;

trigger-service)
  deleteOldImages
  newVersion
  version=$?
  docker build \
    -t trigger-service:latest \
    -t trigger-service:$version \
    -f ../trigger-service-demo/docker/Dockerfile \
    ../trigger-service-demo/
  kubectl apply -f ./trigger-service/
  kubectl set image deployments/trigger-service-deployment trigger-service=trigger-service:$version
  ;;

*)
  echo "Service not exist"
  ;;
esac
