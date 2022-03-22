#!/bin/bash

echo "install node"
#see https://tecadmin.net/install-latest-nodejs-npm-on-debian/
apt-get -y install curl software-properties-common 
curl -sL https://deb.nodesource.com/setup_17.x |  bash - 
apt-get -y install nodejs 

echo "install datamaker"
npm install -g datamaker

#descargar MySQL APT Repo https://dev.mysql.com/downloads/file/?id=509020/
#pasarlo a la MV
echo "instalar el repo"
sudo dpkg -i mysql-apt-config_0.8.22-1_all.deb

echo "actualizar el repo"
sudo apt-get update

echo "instalar mysql-server"
sudo apt install mysql-server
#--------------------------------------------------------------------------

echo "Create the data template"
echo "SET {{uuid}} '{\"a\":{{integer}},\"txt\":\"{{words 10}}\",\"email\":\"{{email}}\"}'" > template.txt

echo "Create the data. This will take a while because it is creating 350 million rows!"
cat template.txt | datamaker -i 3500 > batch.txt #Manejar la cantidad de datos a crear

#Cambiar las variables "h", "P"
echo "connect into mysql"
mysql -u admin -p -h <host_output_del_paso_4> -P <port_output_del_paso_4>

#Crear la BD
CREATE DATABASE Test;

#Usar la BD
USE Test;

#Crear la tabla
CREATE TABLE Test (ID int,Last varchar(255)); #Según las columnas necesarias

#ingestar los datos
LOAD DATA INFILE '/root/batch.txt' 
INTO TABLE Test
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
TERMINATED BY '\r\n';
