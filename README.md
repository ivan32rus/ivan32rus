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

#Доп. бонус:

# 1. Можем "запушить" проект в DockerHub 
#Запускаем:

make push

# 2. Ключи закомичены, но готовы к бою:

#make deploy
#make cleaning
#make rmi
#make stop_container
#make rm_container
#make rmi_docker_hub

# II. Развертывание инфраструктуры k8s
#---- Период выполнения: 10.05.22-10.05.22

# 1. Собираем образ диска, который будет использоваться
# для развертывания K8s

#!Условие: Установленный packer
#Характеристики диска:
#Ubuntu 2004 Serv x64 , 8RUM, 4CPU, 64Gb HDD

#Перейдем в каталог 

cd ~./k8s/packer

#Запустим сборку образа

packer build k8s-desk.json .

#Результат: Создан образ диска

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

# IV Готовим CI/CD

## ---- Период выполнения: 11.05.22-13.05.22

# V Устранения неисправностей, приготовление к сдаче проекта

## --- Период выполнения: 14.05.22-17.05.22
