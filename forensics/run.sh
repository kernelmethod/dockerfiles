#!/bin/bash

# Start the VNC server
vncserver \
    -SecurityTypes None \
    -xstartup /etc/vnc/xstartup \
    -localhost yes

# Start the NoVNC server to make the container accessible
# through the browser.
launch-novnc \
    --web "${NOVNC_DIRECTORY}" \
    --vnc localhost:5901
