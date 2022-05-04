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
