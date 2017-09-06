#!/bin/sh

if [ -d /etc/shib-certs/ ]; then
    mkdir -p /etc/shibboleth/cert/
    cp /etc/shib-certs/* /etc/shibboleth/cert/
    chown -R _shibd /etc/shibboleth/cert
fi

exec "$@"
