# Docker Compose Test Environment for Patroni

This is a test environment for a small Patroni cluster, in order to test HA, failover, and other 
tools. This repository will eventually include a functional test suite.

## How To Test with Patroni-Compose

1. clone Patroni into a separate directory.
2. checkout the branch you want to test.
3. make a shallow copy of the patroni repo into patroni-compose/patroni
4. make any changes to the configuration you want in scripts/entrypoint.sh
5. make any changes to the cluster setup by creating a new compose file
6. start the cluster using docker-compose up -d, e.g.

    docker-compose -f patroni-compose-etcd-3.yml up -d
    
7. use docker-compose logs to see if the cluster came up properly
8. start testing the cluster in other ways



