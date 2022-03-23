#!/bin/bash

echo "install node"
#see https://tecadmin.net/install-latest-nodejs-npm-on-debian/
apt-get -y install curl software-properties-common 
curl -sL https://deb.nodesource.com/setup_17.x |  bash - 
apt-get -y install nodejs 

echo "install datamaker"
npm install -g datamaker

#Solo modifica el número de iteraciones si quieres más filas
echo "creando data"
echo "{{uuid}},{{integer}},{{firstname}} {{surname}},{{words 10}},{{email}}" | datamaker --format csv --iterations 500 > batch.csv

#descargar el archivo .deb "https://dev.mysql.com/downloads/repo/apt/"
echo "instalando repositorio"
dpkg -i mysql-apt-config_0.8.22-1_all.deb

echo "actualizar repositorio"
apt-get update

echo "instalar mysql-server"
apt-get install mysql-server

echo "conectandose al mysql"
mysql --local-infile=1 -u admin -p -h <your_mysql_host> -P <your_mysql_port>
