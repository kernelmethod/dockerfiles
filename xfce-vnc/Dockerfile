FROM ubuntu:18.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y \
            xfce4 \
            xfce4-goodies \
            tigervnc-standalone-server \
            tigervnc-xorg-extension \
            tigervnc-viewer

# Configure VNC
ENV TERM=xterm-256color

RUN mkdir /etc/vnc
COPY xstartup /etc/vnc/
COPY msg.txt /etc/vnc/

# Restrict permissions in /etc/vnc
RUN chmod a-w /etc/vnc/*

# Change x-terminal-emulator to /usr/bin/xfce4-terminal.wrapper so that we
# avoid "input/output error" when attempting to open a terminal in a VNC
# session.
RUN bash -c "update-alternatives --config x-terminal-emulator <<< 2"

# Expose ports for VNC
EXPOSE 5900-6000

CMD cat /etc/vnc/msg.txt
