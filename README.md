##PROJECT OTUS-DEV-O1

### --- ОПИСАНИЕ МЕНЯЕТСЯ РЕГУЛЯРНО!


#I. Подготовка к развертыванию архитектуры:
# Период выполнения: 27.04-05.05.22
#Доп. работы до 18.05.22

#1. Сборка Docker:

##--------
#/logging
#/monitoring
#-----------
# запускаем все контейнеры, видим stdout всех контейнеров
# для остановки используем Ctrl+C
docker-compose up
## или
docker-compose -f docker-compose-logging.yml
# запуск в режиме демона
docker-compose up -d
## или
docker-compose -f docker-compose-logging.yml up -d
# для остановки используем
docker-compose stop
# для остановки с удалением контейнеров
docker-compose down
## или
docker-compose -f docker-compose-logging.yml down
##---------------
#/prog/ui
#/prog/crawler
##--------------
#Сборка проектов предсвлена в соответвующих каталогах
#2. Билдинг проекта
#Сборка проекта осуществляется с помощь Makefile файла.
#Переходим в каталог builder:
cd /builder
#Запускае:
make build
#Результат - собранный проект: ui, crawler, logging, monitoring
# Доп. бонус:
# 1. Можем запушить проект в DockerHub 
# Запускаем:
make push

#2. Ключи закомичены, но готовы к бою
#make deploy
#make cleaning
#make rmi
#make stop_container
#make rm_container
#make rmi_docker_hub

#II. Развёртывание инфраструктуры k8s
##---- Период выполнения: 05.05.22-10.05.22
#1. Собираем образ для использования при завретывания K8s

#Условие: Установленный packer

#Описание установки packer....

# Ubuntu 2004 Serv x64 , 8 RUM, 64Gb HDD

# Перейдем в каталог 
cd /k8s/packer
# запустим сборку образа
packer build k8s-desk.json .
# Результат: Создан образ диска
#2. Развертывание архитектуры k8s c помощью Terraform
#Условие: Установленный Terraform
#Описание установки Terrafor....
#Перейти в каталог:

cd /k8s/terraform

#Запустить установку кластера
## --Сделать описание предварителььных работ, создание учтетных данных в YC и т.д.
terraform apply
#!!!
#III. Диплой приложения
##---- Период выполнения: 10.05.22-18.05.22

#IV Готовим CI/CD
##---- Период выполнения: 10.05.22-18.05.22
