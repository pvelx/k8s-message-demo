Это приложение является демострацией работы 
[Trigger Hook](https://github.com/pvelx/triggerhook).  


Приложение разворачивается при помощи Kubernetes.

Состоит из 5 микросервисов:
- **[Admin Dashboard](https://github.com/pvelx/message-dashboard-demo)** - панель администратора для доступа к API сервиса Message. Интерфейс построен на базе фреймворка Vue.
- **[Message service](https://github.com/pvelx/message-service-demo)** - отвечает за управление сообщениями. Создание, удаление, отложенная отправка. Написан на базе фреймворка Symfony 5 (PHP).
- **Broker** - брокер сообщений RabbitMQ для асинхронного взаимодействия.
- **Monitoring** - мониторинг сервиса Trigger. Отображаемые метрики описаны [тут](https://github.com/pvelx/triggerhook#%D0%BF%D1%80%D0%B8%D0%BD%D1%86%D0%B8%D0%BF-%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%8B). Построен на базе InfluxDb + Grafana.
- **[Trigger service](https://github.com/pvelx/trigger-service-demo)** - сервис реализует механизм отложенного выполенения задач. Построен на безе [Trigger Hook](https://github.com/pvelx/triggerhook).


### Локальное развертывание

#### Прежде всего должны быть установлены следующие приложения:
- docker
- kubectl
- minikube
- git

Для MacOs в качесве драйвера лучше дополнительно установить virtualbox или parallels. Docker в качестве драйвера на данной системе может работать медленно. 

#### Запустите виртуальную машину для приложения:
```bash
minikube start
```
Вы можете использовать другой драйвер, например, virtualbox или parallels:
```bash
minikube start --vm-driver=parallels
```
#### Клонирование репозиториев проекта:
```bash
mkdir trigger-hook-demo && trigger-hook-demo

git clone https://github.com/pvelx/k8s-message-demo.git

cd k8s-message-demo

./download.sh
```

#### Развертывание на виртуальной машине:
```bash
./deploy.sh
```
Это может занять несколько минут.

#### Добавление в файл /etc/hosts URLs сервисов
Для доступа сервисам с локальной машины нужно выполнить:
```bash
./update_hosts.sh
```
С развернутого хоста стануд доступны сервисы по ссылкам:
- [dashboard.message.com](http://dashboard.message.com)
- [api.message.com](http://api.message.com)
- [monitoring.message.com](http://monitoring.message.com)
- [rabbitmq.message.com](http://rabbitmq.message.com)  
    login:rabbitmq  
    password:secret

#### Открытие приборной панели Kubernetes
```bash
minikube dashboard
```

#### Пересборка сервисов
После изменений кода в одном из сервисов нужно будет его пересобрать:

```bash
./build.sh trigger-service
```

```bash
./build.sh message-service
```

```bash
./build.sh message-dashboard
```

#### Удаление
Для удаления сервисов из виртуальной машины можно использовать:
```bash
./undeploy.sh
```
Для полного удаления:
```bash
minikube stop
minikube delete
```

### Общая схема взаимодействия
![](./scheme.png)

