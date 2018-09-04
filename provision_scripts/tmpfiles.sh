#!/bin/bash

FILENAME=$(echo $APP)

################################
# Create /var/run/hyku on boot #
################################
cp /tmp/config/"$FILENAME"_run.conf /etc/tmpfiles.d/"$FILENAME".conf