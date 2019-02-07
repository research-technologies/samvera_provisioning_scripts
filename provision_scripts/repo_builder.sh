#!/bin/bash

############################################
# This script will install and configure:  #
# - rbenv                                  #
# - hyku/hyrax                                 #
############################################

echo SETTING LOCAL VARIABLES

USER=$(echo $APPLICATION_USER)
APPKEY=$(echo $APPLICATION_KEY)
GEM_KEY=$(echo $GEM_KEY)
GEM_SOURCE=$(echo $GEM_SOURCE)

if [ "$(whoami)" != $USER ]; then
  echo "Script must be run as user: $USER"
  exit -1
fi

if [$APPKEY == hyku]; then
	APP_URL = $(echo $APP_URL)
	BRANCH = 2.0.0
fi

if [$APPKEY == hyrax]; then
	APP_URL = 'https://github.com/research-technologies/hyrax_leaf'
	BRANCH = 'master'
fi

sudo chmod +x *
if [ ! -d /home/$USER/rbenv ]; then
	echo installing rbenv
	cd /tmp/
	wget https://raw.githubusercontent.com/research-technologies/samvera_provisioning_scripts/master/provision_scripts/rbenv.sh
	sudo chmod +x rbenv.sh
   ./rbenv.sh
fi

echo -n "Have you created/added a private key for $USER and added it to $GEM_SOURCE (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	sudo mkdir /data/$APPLICATION_KEY
	sudo chown -R $USER:$USER /data/$APPLICATION_KEY
	sudo -u $USER mkdir -p /data/$APPLICATION_KEY/derivatives /data/$APPLICATION_KEY/uploads /data/$APPLICATION_KEY/imports /data/$APPLICATION_KEY/working /data/$APPLICATION_KEY/network_files
	sudo -u $USER cd /var/lib
	sudo -u $USER git clone $APP_URL --branch $BRANCH /var/lib/$APPLICATION_KEY
	sudo ln -s /data/$APPLICATION_KEY/branding /var/lib/$APPLICATION_KEY/public/branding
	sudo -u $USER git clone git@$GEM_SOURCE/$GEM_KEY.git /var/lib/$APPLICATION_KEY/vendor/$GEM_KEY
	wget https://raw.githubusercontent.com/research-technologies/samvera_provisioning_scripts/master/provision_scripts/setup.sh
	sudo chmod +x setup.sh
	./setup.sh

	echo 'Start puma, sidekiq; restart apache'
	echo 'sudo systemctl start sidekiq'
	echo 'sudo systemctl start puma'
	echo 'sudo systemctl restart httpd'
else
    echo "Sort the key, then re-run this script."
fi
