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
    
7. use docker-compose logs to see if the cluster came up properly:

    docker-compose -f patroni-compose-etcd-3.yml logs

8. start testing the cluster in other ways
9. Shut down the test cluster with:

    docker-compose -f patroni-compose-etcd-3.yml stop

## Requirements

* docker 1.8+
* docker-compose 1.4+

## Example Tests

1. Kill the master and see if failover works.  For example, if the master is node2:

    docker stop dbnode2_1
    
2. add a node and see if it joins the cluster:

    docker-compose -f patroni-compose-addnode.yml up -d

Note that if you add a node using the addnode compose script, you will need to shut it down separately with:

    docker-compose -f patroni-compose-addnode.yml stop
    
# Running multiple tests

If you take down the docker-compose cluster after a failed test run, and bring it back up, you may find that PostgreSQL doesn't start. This is because the etcd server still has a record for the failed master, but there's no valid node in the cluster.

The solution to this is to remove all the containers and start fresh:

    docker-compose -f patroni-compose-etcd-23.yml rm
    
If you've done several addnodes, etc., you may need to look a "docker ps -a" and "rm" multiple containers by hand.
    


    

