# This dockerfile is meant to help with setup and testing of 
# patroni nodes.  Unlike the prior docker setup, it relies on 
# docker compose to set up multiple nodes.

FROM ubuntu:trusty

ADD ./scripts/ /scripts/

RUN /scripts/package_install.sh 9.4

RUN /scripts/file_setup.sh

EXPOSE 8001 5432

ENTRYPOINT ["/bin/bash", "/scripts/entrypoint.sh"]
USER postgres
