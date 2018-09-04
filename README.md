# README #

## Samvera Provisioning Scripts ##

Set of configs and scripts intended for use in provisioning TEST and DEVELOPMENT servers for Hyrax or Hyku, eg. for use with Vagrant. These are NOT production-ready scripts.

The scripts are written for use with Centos 7.

The scripts rely on ENV variables and config files located in /tmp/config/ as follows:

provision_apache.sh

```
$APP
/tmp/config/$APP.conf
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
/tmp/fits-$FITS.zip
```

provision_solr.sh

```
$SOLR_VERSION
$SOLR_USER
$APP
/tmp/config/security.json
```

provision_user.sh

```
$APPUSER
$APP
```

puma.sh

```
$APP
/tmp/config/"$APP"_puma.service
```

sidekiq.sh

```
$APP
/tmp/config/"$APP"_puma.service
```

tmpfiles.sh

```
$APP
/tmp/config/"$APP"_run.conf
```

rbenv.sh

```
$RBENV_RUBY_VERSION
$RBENV_RAILS_VERSION
$APPUSER
```

