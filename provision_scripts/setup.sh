#!/bin/bash

USER=$(echo $APPLICATION_USER)
APP_NAME=$(echo $APPLICATION_NAME)
APP_KEY=$(echo $APPLICATION_KEY)
GEM_KEY=$(echo $GEM_KEY)
DB_PASS=$(echo $RDS_PASSWORD)
SMTP_PASS=$(echo $SMTP_PASSWORD)
FQDN=$(echo $APPLICATION_HOST)
FEDORA_PASS=$(echo $FEDORAPASS)
SOLR_PASS=$(echo $SOLRPASS)
FEDORA_URL_FULL="http://127.0.0.1:8080/fcrepo/rest"
SOLR_URL_PART="127.0.0.1:8983"
DB=$APP_KEY
DB_USER=$APP_KEY
FEDORA_USER=$(echo $FEDORAUSER)
SOLR_USER=$(echo $SOLR_USER)
GEONAMES=$(echo $GEONAMES)
CONTACT_EMAIL=$(echo $CONTACT_EMAIL)
FROM_EMAIL=$(echo $FROM_EMAIL)
IIIF_SEARCH_ENDPOINT=$(echo $IIIF_SEARCH_ENDPOINT)
CONFIG_IIIF_IMAGE_ENDPOINT=$(echo $CONFIG_IIIF_IMAGE_ENDPOINT)
SSL_ON=$(echo $SSL_ON)

if [ "$(whoami)" != $USER ]; then
  echo "Script must be run as user: $USER"
  exit -1
fi

# Make sure we our rbenv setup loaded
source ~/.bash_profile

cd "/var/lib/$USER"

wget https://raw.githubusercontent.com/research-technologies/samvera_provisioning_scripts/master/config/.rbenv-vars-todo -O .rbenv-vars

sed -i "s/APPLICATION_NAME_TODO/$APP_NAME/g" .rbenv-vars

sed -i "s/APPLICATION_KEY_TODO/$APP_KEY/g" .rbenv-vars

sed -i "s/APPLICATION_USER_TODO/$USER/g" .rbenv-vars

sed -i "s/RDS_DB_NAME_TODO/$DB/g" .rbenv-vars

sed -i "s/RDS_USERNAME_TODO/$DB_USER/g" .rbenv-vars

sed -i "s/RDS_PASSWORD_TODO/$DB_PASS/g" .rbenv-vars

sed -i "s/SMTP_PASSWORD_TODO/$SMTP_PASS/g" .rbenv-vars

sed -i "s/APPLICATION_HOST_TODO/$FQDN/g" .rbenv-vars

# use a different delimeter for urls (/)
sed -i "s&SOLR_URL_TODO&http://$SOLR_USER:$SOLR_PASS@$SOLR_URL_PART/solr&g" .rbenv-vars
sed -i "s&FEDORA_URL_TODO&"$FEDORA_URL_FULL"&g" .rbenv-vars

sed -i "s/FEDORA_USER_TODO/$FEDORA_USER/g" .rbenv-vars

sed -i "s/FEDORA_PASSWORD_TODO/$FEDORA_PASS/g" .rbenv-vars

sed -i "s/CONTACT_EMAIL_TODO/$CONTACT_EMAIL/g" .rbenv-vars

sed -i "s/FROM_EMAIL_TODO/$FROM_EMAIL/g" .rbenv-vars

sed -i "s/GEONAMES_TODO/$GEONAMES/g" .rbenv-vars

if [ "$IIIF_SEARCH_ENDPOINT" != "" ]; then
  # use a different delimeter
  sed -i "s&# IIIF_SEARCH_ENDPOINT=IIIF_SEARCH_ENDPOINT_TODO&IIIF_SEARCH_ENDPOINT=$IIIF_SEARCH_ENDPOINT&g" .rbenv-vars
fi
if [ "$CONFIG_IIIF_IMAGE_ENDPOINT" != "NO" ]; then
  sed -i "s/# IIIF_IMAGE_ENDPOINT/IIIF_IMAGE_ENDPOINT/g" .rbenv-vars
fi

if [ "$SSL_ON" == 1 ]; then
  sed -i "s/# SSL_CONFIGURED=/SSL_CONFIGURED=/g" .rbenv-vars
fi

rbenv vars

# Insert gems
if ! grep -q "$GEM_KEY" "/var/lib/$USER/Gemfile"; then
  echo -e "\ngem '"$GEM_KEY"', :path => 'vendor/"$GEM_KEY"'" >> /var/lib/$APP_KEY/Gemfile
fi

bundle install --without development test
# sed -i "s/gem 'iiif_manifest', '~> 0.3.0'/gem 'iiif_manifest', '~> 0.4.0'/g" Gemfile
# bundle update iiif_manifest --conservative
# bundle update devise --conservative

# remove anything not in Gemfile
bundle clean --force

KEY=$(rake secret)
sed -i "s/SECRET_KEY_BASE_TODO/$KEY/g" .rbenv-vars

# generators will fail if db doesn't exist
# if it doesn't, run: 
# rake db:create

rails g $GEM_KEY:install --initial -f 

# add the qa index as per https://github.com/samvera/questioning_authority
echo 'Add the index to the database'
bash -c " PGPASSWORD=$DB_PASS psql -U $USER -h 127.0.0.1 $USER -c \"CREATE INDEX index_qa_local_authority_entries_on_lower_label ON qa_local_authority_entries (local_authority_id, lower(label));\""
