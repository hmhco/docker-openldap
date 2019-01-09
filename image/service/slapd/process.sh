#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

# Reduce maximum number of number of open file descriptors to 1024
# otherwise slapd consumes two orders of magnitude more of RAM
# see https://github.com/docker/docker/issues/8231
ulimit -n $LDAP_NOFILE

if [ -z "$LDAP_PORT" ]; then
    LDAP_CONNETION_STRING=$HOSTNAME
else
    LDAP_CONNETION_STRING=$HOSTNAME:$LDAP_PORT
fi

if [ -z "$LDAPS_PORT" ]; then
    LDAPS_CONNETION_STRING=$HOSTNAME
else
    LDAPS_CONNETION_STRING=$HOSTNAME:$LDAPS_PORT
fi


exec /usr/sbin/slapd -h "ldap://$LDAP_CONNETION_STRING ldaps://$LDAPS_CONNETION_STRING ldapi:///" -u openldap -g openldap -d $LDAP_LOG_LEVEL
