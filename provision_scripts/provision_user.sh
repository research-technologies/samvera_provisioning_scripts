#!/bin/bash

USER=$(echo $APPUSER)
APP=$(echo $APP)

##################
# Add user/group #
##################
echo 'Adding the user'
adduser $USER
groupadd $USER
usermod -a -G $USER $USER

########################################
# Create direcotories, change ownerhip #
########################################
mkdir /var/lib/$APP
mkdir /var/log/$APP
mkdir /var/run/$APP
mkdir -p /data/$APP

chown $USER:$USER /var/lib/$APP
chown $USER:$USER /var/log/$APP
chown $USER:$USER /var/run/$APP
chown $USER:$USER /data/$APP

#############################################################
# Setup the db user, create the db and grant all privileges #
#############################################################
sudo -u postgres bash -c "psql -c \"CREATE USER $USER WITH PASSWORD '$USER';\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE $APP;\""
sudo -u postgres bash -c "psql -c \"GRANT ALL ON DATABASE $APP TO $USER;\""