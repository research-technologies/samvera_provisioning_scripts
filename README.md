# README #

## Samvera Provisioning Scripts ##

Set of configs and scripts intended for use in provisioning TEST and DEVELOPMENT servers for Hyrax or Hyku, eg. for use with Vagrant. These are NOT production-ready scripts.

The scripts are written for use with Centos 7.

The scripts rely on ENV variables and config files located in /tmp/config/ as follows:

provision_apache.sh

```
$APPLICATION_KEY # eg. hyrax
/tmp/config/$APPLICATION_KEY.conf
```

provision_fcrepo.sh

```
$FCREPO_VERSION
/tmp/config/repository.json
/tmp/config/logback.xml
```

provision_prereq.sh

```
$FITS_VERSION
/tmp/fits-$FITS_VERSION.zip
```

provision_solr.sh

```
$SOLR_VERSION
$SOLR_USER
$APPLICATION_KEY # eg. hyrax
/tmp/config/security.json
```

provision_user.sh

```
$APPLICATION_USER # eg. hyrax, used across multiple scripts
$APPLICATION_KEY # eg. hyrax, used across multiple scripts
```

puma.sh

```
$APPLICATION_KEY # eg. hyrax
/tmp/config/"$APPLICATION_KEY"_puma.service
```

sidekiq.sh

```
$APPLICATION_KEY # eg. hyrax
/tmp/config/"$APPLICATION_KEY"_puma.service
```

tmpfiles.sh

```
$APPLICATION_KEY # eg. hyrax
/tmp/config/"$APPLICATION_KEY"_run.conf
```

rbenv.sh

```
$RBENV_RUBY_VERSION
$RBENV_RAILS_VERSION 
$APPLICATION_USER # eg. hyrax
```

repo_builder.sh

```
$APPLICATION_KEY
$APPLICATION_USER
$GEM_SOURCE # eg. bitbucket.org:ulcc-art
$GEM_KEY # gem name

```

setup.sh

```
$APPLICATION_NAME # display name, eg. CoSector Data Repository
$APPLICATION_USER
$APPLICATION_KEY 
$APPLICATION_HOST # fdqn
$GEM_KEY
$RDS_PASSWORD
$SMTP_PASSWORD
$FEDORAPASS
$SOLRPASS
$FEDORAUSER
$GEONAMES
$CONTACT_EMAIL
$FROM_EMAIL
$IIIF_SEARCH_ENDPOINT # endpoint url, set to '' for no endpoint
$CONFIG_IIIF_IMAGE_ENDPOINT # use NO to stick with default RIIIF endpoint
```

