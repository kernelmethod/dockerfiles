#!/bin/bash

# Start the VNC server
vncserver \
    -SecurityTypes None \
    -xstartup /etc/vnc/xstartup \
    -localhost yes

launch-novnc \
    --web ${NOVNC_DIRECTORY} \
    --vnc localhost:5901

# Wait indefinitely
tail -f /dev/null
