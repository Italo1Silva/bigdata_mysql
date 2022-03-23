#!/bin/bash

echo "install node"
#see https://tecadmin.net/install-latest-nodejs-npm-on-debian/
apt-get -y install curl software-properties-common 
curl -sL https://deb.nodesource.com/setup_17.x |  bash - 
apt-get -y install nodejs 

echo "install datamaker"
npm install -g datamaker

#--------------------------------------------------------------------------

echo "Create the data template"
echo "SET {{uuid}} '{\"a\":{{integer}},\"txt\":\"{{words 10}}\",\"email\":\"{{email}}\"}'" > template.txt

echo "Create the data. This will take a while because it is creating 350 million rows!"
cat template.txt | datamaker -i 3500 > batch.txt #Manejar la cantidad de datos a crear

echo "instalando ibmcloud cli"
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

echo "instalando cloud-databases plugin"
ibmcloud plugin install cloud-databases

echo "conectandose a su cuenta IBM Cloud"
ibmcloud login --apikey <key>

echo "conectandose a su base de datos"
ibmcloud cdb cxn -s <your_mysql_crn>
