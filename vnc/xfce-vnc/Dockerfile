ARG FROM_IMAGE
FROM "${FROM_IMAGE}"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y \
            xfce4 \
            xfce4-goodies \
            sudo \
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure VNC
ENV TERM=xterm-256color
COPY xstartup /etc/vnc/

# Change x-terminal-emulator to /usr/bin/xfce4-terminal.wrapper so that we
# avoid "input/output error" when attempting to open a terminal in a VNC
# session.
RUN rm -f \
        $(which x-terminal-emulator) \
        /etc/alternatives/x-terminal-emulator \
    && ln -s \
        /usr/bin/gnome-terminal.wrapper \
        /usr/bin/x-terminal-emulator
