#!/bin/bash

SOLR=$(echo $SOLR_VERSION)
USER=$(echo $SOLR_USER)
COLLECTION=$(echo $APP)

##################
# Add user/group #
##################
echo 'Adding the solr user'
adduser $USER
groupadd $USER
usermod -a -G $USER $USER

##############################
# Install and configure solr #
##############################
yes | sudo yum install -y java-1.8.0-openjdk.x86_64 wget unzip lsof

cd /tmp
if [ ! -f solr-$SOLR.tgz ]
then
    wget http://archive.apache.org/dist/lucene/solr/$SOLR/solr-$SOLR.tgz
    tar -xvf solr-$SOLR.tgz
else
    echo 'solr is already downloaded'
fi
/tmp/solr-$SOLR.tgz
mv /tmp/solr-$SOLR /var/lib/solr

# Use -force when running as root
cd /var/lib/solr
bin/solr start -force
# Create a Collection
bin/solr create -c $COLLECTION -force
bin/solr stop -force
cd server/solr/$COLLECTION/conf
mv solrconfig.xml solrconfig.xmlBAK
wget https://raw.githubusercontent.com/samvera/active_fedora/master/lib/generators/active_fedora/config/solr/templates/solr/config/solrconfig.xml
wget https://raw.githubusercontent.com/samvera/active_fedora/master/lib/generators/active_fedora/config/solr/templates/solr/config/schema.xml

chown -R $USER:$USER /var/lib/solr

# copy the security credentials into place
# username and password is solr:solr (password generated using utils/SolrPasswordHash.jar)
cp /tmp/config/security.json /var/lib/solr/server/solr/security.json

####################################
# Add sidekiq as a systemd service #
####################################
cp /tmp/config/solr.service /etc/systemd/system/

######################
# Change permissions #
######################
chmod 664 /etc/systemd/system/solr.service

####################
# Reload systemctl #
####################
systemctl daemon-reload

#####################
# Enable at startup #
#####################
systemctl enable solr.service

##############
# Start solr #
##############
service solr start

# Notes
# To get rid of StackOverflow Errors, commnt out the two /suggest blocks in solrconfig 
#   or (if we want the service) set buildOnCommit to false and request a build of suggest during idle hours via something like 
#   https://localhost:8983/solr/mycore/select?suggest.build=true
# (this is now default in active fedora)
# To get rid of warns, set luceneMatchVersion in solrconfig
#   and change deprecated Trie* fields to *Point eg TrieInt to IntPoint (need to delete the precision bit) in schema.xml
#   and LatLongType to LatLonPointSpatialField (need to delete the subfield bit) in schema.xml
