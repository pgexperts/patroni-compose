#!/bin/bash

mkdir /pgdata/
mkdir /pgdata/data
chown postgres:postgres /pgdata/data/
chmod 700 /pgdata

mkdir /etc/patroni/

mkdir /etc/wal-e.d/

ln -s /usr/lib/postgresql/9.3/bin/pg_ctl /usr/bin/