#!/bin/bash

apt-get update
apt-get -y -q install wget

# fix locale
apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# setup apt-get to pull from apt.postgresql.org
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.4" > /etc/apt/sources.list.d/pgdg.list
wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -

# update apt
apt-get update
apt-get -y -q install pgdg-keyring

# install some basics
apt-get -y -q install libreadline-dev

# install postgresql and a bunch of accessories
apt-get -y -q install postgresql-client-9.4
apt-get -y -q install postgresql-9.4
apt-get -y -q install postgresql-contrib-9.4
apt-get -y -q install postgresql-server-dev-9.4

#  install extensions
#apt-get -y -q install postgresql-9.4-postgis-2.1 postgresql-9.4-postgis-2.1-scripts

# install WAL-E requirements
apt-get -y -q install python-pip
apt-get -y -q install python-dev

# install WAL-E
pip install -U six
pip install -U requests
pip install -U wal-e
apt-get -y install daemontools
apt-get -y install lzop pv

# install patroni dependancies
apt-get -y install python-yaml
pip install -U setuptools
python /mnt/patroni/setup.py install

