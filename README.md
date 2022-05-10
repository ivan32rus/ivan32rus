# PROJECT OTUS-DEV-O1
# Сборка и деплой дипломного проект
# Код предоставлен express42
#https://github.com/express42/search_engine_ui

#https://github.com/express42/search_engine_crawler

## --- ОПИСАНИЕ МЕНЯЕТСЯ РЕГУЛЯРНО!

#!Пункт раздела II-1 (Packer) более не используется

#образ диска создается автоматически в Terraform

#соответствующая конфигурация внесена в main.tf 

# I. Подготовка к развертыванию архитектуры: 
#Период выполнения: 27.04-05.05.22. Доп. работы до 18.05.22

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

#---- Период выполнения: 6.05.22-10.05.22

# 1. Собираем образ диска, который будет использоваться для развертывания K8s

#!Условие: Установленный packer

#Инструкция по устновке packer:

#https://cloud.yandex.ru/docs/tutorials/infrastructure-management/packer-quickstart

#Наши характеристики диска:

#Ubuntu 2004 Serv x64 , 8RUM, 4CPU, 64Gb HDD

#Перейдем в каталог 

cd ~./k8s/packer

#Запускаем сборку образа с указанными в конфигурации параметрами:

packer build k8s-desk.json .

#Результат: Создан образ диска

#нам необходим его id (смотрим в консоли при создании или в консоли YC)

#id диска укажим в разделе ~./k8s/terraform/main.tf:

    boot_disk {
      initialize_params {
        image_id = "<YOUR image a packer>" # Ubuntu 20.04 LTS
      }
    }

# 2. Развертывание архитектуры k8s c помощью Terraform

#!Условие: Установленный Terraform

#Инструкция по установке и настройке Terraform в Яндекс:

#https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform

#!В данном проекте для работы с кластером создается пользователь 

#k8s-test с ролью "editor"

#ssh ключ и путь произвольные и указываются "СВОИ"

# Установим k8s в Яндекс

#Перейти в каталог:

cd ~./k8s/terraform

#!Внимание:

#В нашей работе используетются default парметры для folder_id" зоны и роли кластера

#для того, чтобы использовать своего пользователя со своей ролью и folder_id

#следуйте руководству:

#https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create

#тогда можно раскомментировать блоки и создать пользователя для работы с кластером,
 
resource "yandex_resourcemanager_folder_iam_binding" "editor"

resource "yandex_resourcemanager_folder_iam_binding" "images-puller"

depends_on

#Далее

#Проинициализируем Terraform:

terraform init

#Проверим конфигурацию:

terraform validate

#и

terraform plan

#Запустим установку кластера

terraform apply

# III. Диплой приложения

##---- Период выполнения: 06.05.22-10.05.22

#После успешной устновки Кластера

#выполянем действия:

#Установим и инициализируем интерфейс командной строки Yandex.Cloud.

##Ссылки на документацию Yandex.Cloud

##https://cloud.yandex.ru/docs/cli/quickstart#install

##https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-get-credetials

#Добавим учетные данные кластера Kubernetes в конфигурационный файл kubectl:

yc managed-kubernetes cluster get-credentials --id <id вашего кластера> --internal

#Используйте утилиту kubectl для работы с кластером Kubernetes:

#Например посмотрим ноды установленного кластера:

kubectl get node

# 3.1 Переходим к диплою приложения

#перейдем в каталог:

cd ~.k8s/deployments

#содержимое каталога:

#namespaces.yml

#crawler-deployment.yml

#crawler-service.yml

#mongodb-deployment.yml

#mongodb-service.yml

#rabbitmq-deployment.yml

#rabbitmq-service.yml

#ui-deployment.yml

#ui-ingress.yml

#ui-service.yml

#Создаем три namespaces: monitoring, dev, prod

#Выполним команду:

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

#Результат успешного диплоя можно посмотреть командой:

kubectl get pods -n dev 

#Результат:

NAME                       READY   STATUS    RESTARTS   AGE

crawler-77d5bb6c56-7ptmj   1/1     Running   0          14m

crawler-77d5bb6c56-dwckw   1/1     Running   0          14m

crawler-77d5bb6c56-sgwq9   1/1     Running   0          15m

mongodb-7f777c8985-594r9   1/1     Running   0          47m

rabbitmq-f486f4785-w9vcn   1/1     Running   0          48m

ui-55f5d5484f-9dhxl        1/1     Running   0          14m

ui-55f5d5484f-j9wnm        1/1     Running   0          15m

ui-55f5d5484f-scrcm        1/1     Running   0          15m

#3.2 Запуск диплоя проложений для мониторинга и логирования [ ! в работе ]:

cd ~./log_monitor

#запуск в namespace monitoring/

kubectl apply -f fluent-deployment.yml -n monitoring

kubectl apply -f prometheus-deployment.yml -n monitoring

#3.3 Устновка с использованием charts манифестов [ ! в работе ]

# IV Готовим CI/CD

## ---- Период выполнения: 6.05.22-10.05.22

# V Устранения неисправностей, приготовление к сдаче проекта

## --- Период выполнения: 14.05.22-17.05.22
