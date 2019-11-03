FROM debian:buster-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y \
            xfce4 \
            xfce4-goodies \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y \
            git \
            tigervnc-standalone-server \
            tigervnc-xorg-extension \
            openssl \
            procps \
            python3 \
            python3-pip \
            sudo \
    && git clone \
        --depth 1 \
        https://github.com/novnc/noVNC.git \
        /usr/share/noVNC \
    && git clone \
        --depth 1 \
        https://github.com/novnc/websockify.git \
        /usr/share/noVNC/utils/websockify \
    && pip3 install --no-cache-dir numpy \
# Cleanup
    && apt-get remove -y \
        git \
        python3-pip \
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/vnc \
    && ln -s \
        $(which python3) \
        $(dirname $(which python3))/python \
    && ln -s \
        /usr/share/noVNC/utils/launch.sh \
        /usr/bin/start-novnc

ADD xstartup /etc/vnc/
