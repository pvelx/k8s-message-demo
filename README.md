## Demo of the [Trigger Hook](https://github.com/pvelx/triggerhook).  

Configuration of the demo application infrastructure in the Kubernetes cluster.

For a deeper understanding, read [this article](https://vlad-pavlenko.medium.com/deferred-tasks-in-a-microservice-architecture-8e7273089ee7).

![General scheme](./service_scheme.png)

- **[Message dashboard](https://github.com/pvelx/message-dashboard-demo)** - admin panel for accessing the Message API. The interface is based on the Vue framework.
- **[Message service](https://github.com/pvelx/message-service-demo)** - responsible for managing messages. Creating, deleting, and deferred sending. It is written on the basis of the Symfony 5 framework (PHP).
- **Broker** - RabbitMQ message broker for asynchronous communication.
- **Monitoring** - monitoring the Trigger service. The displayed metrics are described [here](https://github.com/pvelx/triggerhook#principle-of-operation). Built on the basis of InfluxDb + Grafana.
- **[Trigger service](https://github.com/pvelx/trigger-service-demo)** - the service implements the deferred task execution mechanism. Built on the basis of [Trigger Hook](https://github.com/pvelx/triggerhook).


### Local deployment
First of all, the following applications must be installed:
- docker
- kubectl
- minikube
- git

For macOS, it is better to additionally install Virtualbox or Parallels as a driver. Docker as a driver on this system may be slow. 

#### Launch
You can use a non-standard driver, such as Virtualbox or Parallels.
```bash
minikube start
```
or
```bash
minikube start --vm-driver=parallels
```

<br/>

Clone the repositories of the project:
```bash
mkdir trigger-hook-demo && cd trigger-hook-demo

git clone https://github.com/pvelx/k8s-message-demo.git

cd k8s-message-demo && ./download
```

<br/>

Deploying to a VM:
```bash
./deploy
```

It may take about 10 minutes to download container images and launch them before the app is fully operational.

<br/>

To access the services from the local machine, you need to run:
```bash
./update_hosts
```
From the deployed host, services will be available via links:
- [dashboard.message.com](http://dashboard.message.com)
- [api.message.com](http://api.message.com)
- [monitoring.message.com](http://monitoring.message.com/d/yw-A1jaMk/task-service)
- [rabbitmq.message.com](http://rabbitmq.message.com)  
    login:rabbitmq  
    password:secret

<br/>

Opening the Kubernetes Dashboard:
```bash
minikube dashboard
```

#### Rebuilding services
After changing the code in one of the services, you will need to rebuild it:

```bash
./build trigger-service
```

```bash
./build message-service
```

```bash
./build message-dashboard
```

#### Remove
To remove services from a VM, you can use:
```bash
./undeploy
```

<br/>

For complete deletion:
```bash
minikube stop
minikube delete
```

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
