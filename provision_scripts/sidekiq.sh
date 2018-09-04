#!/bin/bash

# TODO https://github.com/seuros/capistrano-sidekiq

FILENAME=$(echo $APP)

####################################
# Add sidekiq as a systemd service #
####################################
sudo cp /tmp/config/"$FILENAME"_sidekiq.service /etc/systemd/system/sidekiq.service

######################
# Change permissions #
######################
sudo chmod 664 /etc/systemd/system/sidekiq.service

####################
# Reload systemctl #
####################
sudo systemctl daemon-reload

#####################
# Enable at startup #
#####################
sudo systemctl enable sidekiq.service
