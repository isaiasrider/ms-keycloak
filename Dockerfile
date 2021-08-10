FROM registry.access.redhat.com/ubi8-minimal:8.4
# build args

ARG DB_HOST
ARG DATABASE_NAME
ARG DATABASE_USER
ARG DATABASE_PASSWORD

# Env Deployment Vars

ENV  DB_PORT 3306
ENV  DB_SCHEMA public
ENV  DB_USER $DATABASE_USER
ENV  DB_ADDR $DB_HOST
ENV  DB_PASSWORD $DATABASE_PASSWORD
#ENV  DB_VENDOR MYSQL
ENV  DB_DATABASE $DATABASE_NAME

# Env Vars
ENV KEYCLOAK_VERSION 14.0.0
ENV JDBC_MYSQL_VERSION 8.0.23
ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING true
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

# debug envars

#ENV KEYCLOAK_LOGLEVEL DEBUG
#ENV WILDFLY_LOGLEVEL DEBUG
#ENV ROOT_LOGLEVEL DEBUG

# Clustering Variables

#ENV JGROUPS_DISCOVERY_PROTOCOL "JDBC_PING"
ENV JGROUPS_DISCOVERY_PROPERTIES "datasource_jndi_name=java:jboss/datasources/KeycloakDS,info_writer_sleep_time=500"
ENV CACHE_OWNERS_AUTH_SESSIONS_COUNT "2"
ENV CACHE_OWNERS_COUNT "2"
# Keycloak Metadata

ARG KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz


USER root

#RUN apk add gzip openssl tar which curl
RUN microdnf update -y && microdnf install -y findutils vim-common vim-enhanced glibc-langpack-en gzip hostname java-11-openjdk-headless openssl tar which yum && microdnf clean all
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && yum update
RUN yum -y install procps
RUN mkdir -p /opt/jboss/startup-scripts/
COPY tools /opt/jboss/tools/
WORKDIR /opt/jboss/tools/
RUN /bin/sh build-keycloak.sh

USER 1000

EXPOSE 8080
EXPOSE 8443
EXPOSE 9990

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]