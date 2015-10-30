#!/usr/bin/python
# arguments are:
#   - cluster scope
#   - cluster role
#   - master connection string

from collections import namedtuple
import logging
import os
import psycopg2
import subprocess
import sys


if sys.hexversion >= 0x03000000:
    long = int

logger = logging.getLogger(__name__)


class Restore(object):

    def __init__(self, scope, role, datadir, connstring, env=None):
        self.scope = scope
        self.role = role
        self.master_connection = Restore.parse_connstring(connstring)
        self.data_dir = datadir
        self.env = os.environ.copy() if not env else env

    @staticmethod
    def parse_connstring(connstring):
        # the connection string is in the form host= port= user=
        # return the dictionary with all components as separare keys
        result = {}
        if connstring:
            for x in connstring.split():
                if x and '=' in x:
                    key, val = x.split('=')
                result[key.strip()] = val.strip()
        return result

    def setup(self):
        pass

    def replica_method(self):
        return self.create_replica_with_pg_basebackup

    def replica_fallback_method(self):
        return None

    def run(self):
        """ creates a new replica using either pg_basebackup or WAL-E """
        method_fn = self.replica_method()
        ret = method_fn() if method_fn else 1
        if ret != 0 and self.replica_fallback_method() is not None:
            ret = (self.replica_fallback_method())()
        return ret

    def create_replica_with_pg_basebackup(self):
        try:
            ret = subprocess.call(['pg_basebackup', '-R', '-D','--xlog-method=stream',
                                   self.data_dir, '--host=' + self.master_connection['host'],
                                   '--port=' + str(self.master_connection['port']),
                                   '-U', self.master_connection['user']],
                                  env=self.env)
        except Exception as e:
            logger.error('Error when fetching backup with pg_basebackup: {0}'.format(e))
            return 1
        return ret

if __name__ == '__main__':
    if len(sys.argv) == 5:
        # scope, role, datadir, connstring
        restore = Restore(*(sys.argv[1:]))
        restore.setup()
        sys.exit(restore.run())
    sys.exit("Usage: {0} scope role datadir connstring".format(sys.argv[0]))
