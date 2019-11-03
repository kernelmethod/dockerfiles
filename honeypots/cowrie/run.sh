#!/bin/sh

if [ -f "/persistent/cowrie.pid" ]
then
    rm /persistent/cowrie.pid
fi

/usr/bin/twistd  \
    --nodaemon \
    -y cowrie.tac \
    --pidfile /persistent/cowrie.pid \
    cowrie
