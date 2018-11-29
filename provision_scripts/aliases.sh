#!/bin/bash

USER=$(echo $APPLICATION_USER)
APP_KEY=$(echo $APPLICATION_KEY)

# Add to main user
echo "alias hy='sudo -u $USER -i'" >> ~/.bash_profile
echo "alias hygo='sudo systemctl start puma && sudo systemctl start sidekiq'" >> ~/.bash_profile
echo "alias hyst='sudo systemctl stop puma && sudo systemctl stop sidekiq'" >> ~/.bash_profile
echo "alias hyre='sudo systemctl restart puma && sudo systemctl restart sidekiq'" >> ~/.bash_profile
echo "alias hytail='tail -f /var/log/$APP_KEY/"$APP_KEY"_production.log'" >> ~/.bash_profile
source ~/.bash_profile

# Add to application user
sudo -u $USER echo "alias hylib='cd /var/lib/$APP_KEY'" | sudo tee -a /home/$USER/.bash_profile
sudo -u $USER echo "alias hytail='tail -f /var/log/$APP_KEY/"$APP_KEY"_production.log'" | sudo tee -a /home/$USER/.bash_profile
sudo -u $USER cat /home/$USER/.bash_profile
