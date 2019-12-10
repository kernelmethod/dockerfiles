ARG FROM_IMAGE
FROM "${FROM_IMAGE}"

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
    && git clone \
        --depth 1 \
        https://github.com/novnc/noVNC.git \
        /tmp/noVNC \
#
# Only keep the files we need from the git repository
    && mkdir -p /usr/share/noVNC \
    && mv /tmp/noVNC/vnc.html       /usr/share/noVNC \
    && mv /tmp/noVNC/app            /usr/share/noVNC \
    && mv /tmp/noVNC/core           /usr/share/noVNC \
    && mv /tmp/noVNC/utils          /usr/share/noVNC \
    && mv /tmp/noVNC/vendor         /usr/share/noVNC \
    && mv /tmp/noVNC/package.json   /usr/share/noVNC \
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
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s \
        $(which python3) \
        $(dirname $(which python3))/python

ADD vnc/ /etc/vnc
ADD x11/ /etc/x11
ADD bin/ /usr/bin
COPY vnc.conf /etc/vnc.conf

EXPOSE 6080

CMD [ "/bin/cat", "/etc/vnc/msg" ]
