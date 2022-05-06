# PROJECT OTUS-DEV-O1

## --- ОПИСАНИЕ МЕНЯЕТСЯ РЕГУЛЯРНО!

# I. Подготовка к развертыванию архитектуры:
#Период выполнения: 27.04-05.05.22
#Доп. работы до 18.05.22

# 1. Сборка Docker для:
#Переходим в соответствующие каталоги:
cd ~./logging 
cd ~./monitoring
#запускаем все контейнеры, видим stdout всех контейнеров
#для остановки используем Ctrl+C

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
#Сборка проекта осуществляется с помощь Makefile файла.
#Переходим в каталог builder:

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
#---- Период выполнения: 10.05.22-10.05.22

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
#нам необходим его id (смотрим в консоли при создании или в кансоли YC)
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

# Устновим k8s в Яндекс
#Перейти в каталог:

cd ~./k8s/terraform

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

###!!!Добавить ОПИСАНИЕ ПРОЦЕССОВ!!!ПОДРОБНО!

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

#3.1 Создаем три namespaces: monitoring, dev, prod

#Создадим namespaces:

kubectl apply -f namespaces.yml

#3.2 Запуск диплоя на примере ui:

kubectl apply -f ui-deployment.yml

#3.3 Устновка с использованием charts манифестов
#в работе

# IV Готовим CI/CD

## ---- Период выполнения: 6.05.22-10.05.22

# V Устранения неисправностей, приготовление к сдаче проекта

## --- Период выполнения: 14.05.22-17.05.22
