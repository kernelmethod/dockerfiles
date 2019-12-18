#!/bin/sh

python3 http.py &
python3 ssh.py &

tail -f /dev/null
