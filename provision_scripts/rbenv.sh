#!/bin/bash

RUBY=$(echo $RBENV_RUBY_VERSION)
RAILS=$(echo $RBENV_RAILS_VERSION)
USER=$(echo $APPUSER)

################################################
# Install rbenv https://github.com/rbenv/rbenv #
# Install rbenv into /usr/local                #
################################################

# See https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-centos-7
# TODO (users/groups if needed) https://blakewilliams.me/posts/system-wide-rbenv-install

echo "Installing rbenv for $USER"

HOMEPATH=/home/$USER

if [ ! -d rbenv ]
then
  echo 'rbenv not installed; installing .rbenv'
  git clone git://github.com/sstephenson/rbenv.git $HOMEPATH/rbenv
  echo "export RBENV_ROOT=$HOMEPATH/rbenv" >> $HOMEPATH/.bash_profile
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> $HOMEPATH/.bash_profile
  echo 'eval "$(rbenv init -)"' >> $HOMEPATH/.bash_profile
  git clone git://github.com/sstephenson/ruby-build.git $HOMEPATH/rbenv/plugins/ruby-build
  git clone https://github.com/rbenv/rbenv-vars.git $HOMEPATH/rbenv/plugins/rbenv-vars
  echo 'export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"' >> $HOMEPATH/.bash_profile
else
  echo 'rbenv is installed, moving on ...'
fi

chown -R $USER:$USER $HOMEPATH

# Reload bash_profile
source $HOMEPATH/.bash_profile

################
# Install ruby #
################

echo 'Installing ruby '$RUBY
N | rbenv install $RUBY
rbenv global $RUBY

#################
# Install rails #
#################

echo 'Installing rails '$RAILS
gem install rails -v $RAILS

exit 0
