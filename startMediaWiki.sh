
#!/bin/bash

#echo "THIS ASSUMES YOU HAVE THE NECESSARY IMAGES,DOCKERFILE,AND LOCAL SETTINGS"
#echo "THIS MEANS YOU WILL ALREADY HAVE THE MYSQL CONTAINER RUNNING, OTHERWISE IT WILL NOT WORK"

#echo "Starting mysql container"

#sudo docker run --name noah-mysql -e MYSQL_ROOT_PASSWORD=123virtual -d mysql

echo "starting \"noahmediawiki\"  on port 8081, which is an instance of noah_media_wiki image"

sudo docker run -p 8081:80 --name noahmediawiki --link noah-mysql:mysql -d noah_media_wiki

echo "starting \"noahmediawiki1\"  on port 8082, which is an instance of noah_media_wiki image"

sudo docker run -p 8082:80 --name noahmediawiki1 --link noah-mysql:mysql -d noah_media_wiki

echo "starting nginx reverse-proxy"

sudo docker run -p 8080:80 -d load-balance-nginx
