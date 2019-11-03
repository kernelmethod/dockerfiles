#!/bin/bash

###
### Convenience script for getting a noVNC server up and running
###

if [ ! $? -eq 1 ]
then
    echo "Usage: start-novnc <vnc-server>"
    exit 1
fi

# Check if TLS certificate has already been generated
mkdir -p ${HOME}/.vnc
if [ ! -f ${HOME}/.vnc/vnc.cert ]
then
    openssl req \
        -x509 \
        -newkey rsa:4096 \
        -keyout ${HOME}/.vnc/vnc.key \
        -out ${HOME}/.vnc/vnc.cert \
        -days 365 \
        -subj '/CN=${USER}' \
        -nodes
fi

/usr/share/noVNC/utils/launch.sh \
    --web /usr/share/noVNC \
    --cert ${HOME}/.vnc/vnc.cert \
    --key ${HOME}/.vnc/vnc.key \
    --ssl-only \
    --vnc $1
