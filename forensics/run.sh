#!/bin/bash

# Start the VNC server
vncserver \
    -geometry ${SCREEN_DIMS} \
    -PasswordFile ${HOME}/.vnc/passwd \
    -xstartup /etc/vnc/xstartup \
    -localhost no \
    -X509Key ${HOME}/.vnc/vnc.key \
    -X509Cert ${HOME}/.vnc/vnc.cert

# Wait indefinitely
tail -f /dev/null
