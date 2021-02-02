deploy_message_service:
	docker build -t message-service:latest -t message-service:$(v) -f ../message-service-demo/docker/Dockerfile ../message-service-demo/
	kubectl apply -f ./message-service/
	kubectl set image deployments/message-service-deployment message-service=message-service:$(v)
	kubectl set image deployments/message-service-daemon-deployment message-service-daemon=message-service:$(v)


deploy_trigger_service:
	docker build -t trigger-service:latest -t trigger-service:$(v) -f ../message-service-demo/docker/Dockerfile ../message-service-demo/
	kubectl apply -f ./message-service/
	kubectl set image deployments/message-service-deployment message-service=message-service:$(v)
	kubectl set image deployments/message-service-daemon-deployment message-service-daemon=message-service:$(v)
