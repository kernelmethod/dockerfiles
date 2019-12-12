#!/bin/sh

vncserver \
    -SecurityTypes None \
    -xstart /etc/vnc/xstartup \
    -localhost yes

launch-novnc \
    --web ${NOVNC_DIRECTORY} \
    --vnc localhost:5901
