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

echo "instalar mysql-shell"
sudo apt-get install mysql-shell
#descargar MySQL APT Repo https://dev.mysql.com/downloads/file/?id=509020/
#pasarlo a la MV
echo "instalar el repo"
sudo dpkg -i mysql-apt-config_0.8.22-1_all.deb

echo "actualizar el repo"
sudo apt-get update

echo "instalar mysql-shell"
sudo apt-get install mysql-shell
#--------------------------------------------------------------------------

echo "install stunnel to allow an https connection"
apt-get install stunnel

echo "move the stunnel config to the right place"
mv stunnel.conf /etc/stunnel/

echo "Starting stunnel..."
stunnel

echo "Create the data template"
echo "INSERT INTO products VALUES ('{{autoinc}}','{{words 5}}', {{price}}, '{{address}}', {{boolean 0.5}});" > template.txt

echo "Create the data. This will take a while because it is creating 350 million rows!"
cat template.txt | datamaker -i 350000000 > batch.txt

echo "Create the auth token to access mysql"
echo auth admin <mysql_password_from_terraform_tf_vars> > auth.txt

#ingresar a mysql-shell "mysqlsh"
echo "connect into mysql"
mysql -u Italo_Silva -p 1234567890 -h https://api.eu-gb.databases.cloud.ibm.com/v5/ibm -P 6830

echo "Pipe the data into mysql"
LOAD DATA INFILE '/root/batch.txt' 
INTO TABLE Test
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
TERMINATED BY '\r\n';
