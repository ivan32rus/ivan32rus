# PROJECT OTUS-DEV-O1
# Код предоставлен express42
#https://github.com/express42/search_engine_ui

#https://github.com/express42/search_engine_crawler

# I. Подготовка к развертыванию архитектуры: 

# 1. Сборка Docker для:
#Переходим в соответствующие каталоги:

cd ~./logging 
cd ~./monitoring

#запускаем все контейнеры, видим stdout всех контейнеров для остановки используем Ctrl+C

docker-compose up

#или

docker-compose -f docker-compose-logging.yml

#запуск в режиме демона

docker-compose up -d

#или

docker-compose -f docker-compose-logging.yml up -d

#для остановки используем

docker-compose stop

#для остановки с удалением контейнеров

docker-compose down

#или

docker-compose -f docker-compose-logging.yml down-

#Точно также соберем и ui/crawler Образы:

cd ~./prog/ui

cd ~./prog/crawler

#!Сборка проектов представлена в соответвующих каталогах

# 2. Билдинг проекта

#Сборка проекта осуществляется с помощь Makefile файла. Переходим в каталог builder:

cd ~./builder

#Запускае:

make build

#Результат - собранный проект: ui, crawler, logging, monitoring

#В нашем случае собранные образы находятся тут:

#https://hub.docker.com/repository/docker/podstolniy

#Доп. бонус:

#2.1. Можем "запушить" проект в DockerHub 

#Запускаем:

make push

#2.2 Ключи закомичены, но готовы к бою:

#make deploy

#make cleaning

#make rmi

#make stop_container

#make rm_container

#make rmi_docker_hub

# II. Развертывание инфраструктуры k8s

# 2. Развертывание архитектуры k8s c помощью Terraform

#Необходимое условие - установленный Terraform

#Инструкция по установке и настройке Terraform в Яндекс:

#https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform

#В данном проекте для работы с кластером создается пользователь k8s-test с ролью "editor", ssh ключ и путь произвольные

# Установим k8s в Яндекс

#Перейти в каталог:

cd ~./k8s/terraform

#Выполняем команды инициализации и проверки конфигурации:

terraform init

terraform validate

terraform plan

#Запускаем установку кластера

terraform apply

# III. Диплой приложения

#Добавим учетные данные кластера Kubernetes в конфигурационный файл kubectl:

yc managed-kubernetes cluster get-credentials --id <id вашего кластера> --internal

# Для удобства диплоя приложений в Кластер, установим Helm:

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -

sudo apt-get install apt-transport-https --yes

echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update

sudo apt-get install helm

# 3.1 Переходим к диплою приложения:

cd ~.k8s/deployments

#Создаем три namespaces: monitoring, dev, prod:

kubectl apply -f namespaces.yml

#Устанавливаем UI, CRAWLER, DB:

#запуск в namespace dev/

# IU

kubectl apply -f ui-deployment.yml -n dev

kubectl apply -f ui-service.yml -n dev

kubectl apply -f ui-ingress.yml -n dev

# CRAWLER

kubectl apply -f crawler-deployment.yml -n dev

kubectl apply -f crawler-service.yml -n dev

# DB

kubectl apply -f mongodb-deployment.yml -n dev

kubectl apply -f mongodb-service.yml -n dev

kubectl apply -f rabbitmq-deployment.yml -n dev

kubectl apply -f rabbitmq-service.yml -n dev

#3.2 Запуск диплоя проложений для мониторинга и логирования:

cd ~./log_monitor

#запуск в namespace monitoring/

kubectl apply -f fluent-deployment.yml -n monitoring

kubectl apply -f prometheus-deployment.yml -n monitoring

#Для того,чтобы узнать адрес порта, на котором работает сервиc, выполните команду:

kubectl get service -n <YOUR namespace>

# Далее вы можите начать работать с сервисом.

#руководство по эксплуатации сервиса в prog/search_engine_crawler и prog/search_engine_ui
