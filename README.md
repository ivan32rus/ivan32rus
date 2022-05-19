# PROJECT OTUS-DEV-O1
____
# Код предоставлен express42
#https://github.com/express42/search_engine_ui

#https://github.com/express42/search_engine_crawler
____


**Состав приложения:**

![Иллюстрация к проекту](https://github.com/ivan32rus/otus-dev-01/tree/main/img/ui.JPG)

____


:white_check_mark: Cделано

# I. Развертывание инфраструктуры k8s

## Развертывание архитектуры k8s c помощью Terraform

**Необходимое условие - установленный Terraform (инструкция по установке и настройке Terraform в Яндекс):**

*https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform*

**Установим k8s в Яндекс**

*Переходим в каталог:*

cd ~./k8s/terraform

*Выполняем команды инициализации и проверки конфигурации:*

terraform init

terraform validate

terraform plan

*Запускаем установку кластера*

terraform apply

**Добавим учетные данные кластера Kubernetes в конфигурационный файл kubectl**

yc managed-kubernetes cluster get-credentials --id <id вашего кластера> --internal

____

:white_check_mark: Cделано

# II. Диплой приложения

kubctl create namespaces ingress-nginx

**Установим Ingress**

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true -n ingress-nginx


## 1 Ставим проложения скриптом

cd ~./deployments

*Выполним скрипт:*

bash service-install.sh apply

**В результате будут установлены приложения:**

*UI, CRAWLER, DB (--namespace dev)* 

*kibama, elc, fluent (--namespace monitoring)*

*Для удаления приложений:*

bash service-install.sh delete

**Далее Вы можите начать работать с сервисом.**

![Иллюстрация к проекту](https://github.com/ivan32rus/otus-dev-01/blob/main/img/ui_v1.JPG)

**руководство по эксплуатации сервиса в prog/search_engine_crawler и prog/search_engine_ui**

____

С Уважением!
