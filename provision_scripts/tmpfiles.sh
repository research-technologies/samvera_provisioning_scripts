#!/bin/bash

FILENAME=$(echo $APPLICATION_KEY)

################################
# Create /var/run/hyku on boot #
################################
cp /tmp/config/"$FILENAME"_run.conf /etc/tmpfiles.d/"$FILENAME".conf