#!/bin/bash

USER=$(echo $APPLICATION_USER)
APPLICATION_KEY=$(echo $APPLICATION_KEY)

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
mkdir /var/lib/$APPLICATION_KEY
mkdir /var/log/$APPLICATION_KEY
mkdir /var/run/$APPLICATION_KEY
mkdir -p /data/$APPLICATION_KEY

chown $USER:$USER /var/lib/$APPLICATION_KEY
chown $USER:$USER /var/log/$APPLICATION_KEY
chown $USER:$USER /var/run/$APPLICATION_KEY
chown $USER:$USER /data/$APPLICATION_KEY

#############################################################
# Setup the db user, create the db and grant all privileges #
#############################################################
sudo -u postgres bash -c "psql -c \"CREATE USER $USER WITH PASSWORD '$USER';\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE $APPLICATION_KEY;\""
sudo -u postgres bash -c "psql -c \"GRANT ALL ON DATABASE $APPLICATION_KEY TO $USER;\""