ARG FROM_IMAGE
FROM "${FROM_IMAGE}"

#
# Install dependencies from apt repositories
RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y \
            tigervnc-standalone-server \
            tigervnc-xorg-extension \
            openssl \
            procps \
            python3 \
            python3-pip \
#
# Install python dependencies
    && pip3 install --no-cache-dir numpy \
#
# Cleanup
    && apt-get remove -y python3-pip \
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

#
# Add NoVNC files
ENV VNC_DIRECTORY=/usr/share/vnc
ENV NOVNC_DIRECTORY="${VNC_DIRECTORY}/noVNC"
RUN apt-get update \
    && apt-get install -y git \
#
# Create a separate directory, VNC_DIRECTORY, in which
# to store NoVNC and websockify. Only keep the files
# from these two repositories that we need.
    && mkdir -p ${VNC_DIRECTORY}/noVNC \
    && git clone \
        --depth 1 \
        https://github.com/novnc/noVNC.git \
        /tmp/noVNC \
    && git clone \
        --depth 1 \
        https://github.com/novnc/websockify.git \
        ${VNC_DIRECTORY}/websockify \
    && mv /tmp/noVNC/vnc.html       ${NOVNC_DIRECTORY} \
    && mv /tmp/noVNC/app            ${NOVNC_DIRECTORY} \
    && mv /tmp/noVNC/core           ${NOVNC_DIRECTORY} \
    && mv /tmp/noVNC/utils          ${NOVNC_DIRECTORY} \
    && mv /tmp/noVNC/vendor         ${NOVNC_DIRECTORY} \
    && mv /tmp/noVNC/package.json   ${NOVNC_DIRECTORY} \
#
# Move the noVNC startup file directly into ${VNC_DIRECTORY}.
# This ensures that the launch script is outside of the
# directory that the NoVNC web server runs on, which could
# have potential security implications.
    && mv \
        ${NOVNC_DIRECTORY}/utils/launch.sh \
        ${VNC_DIRECTORY} \
#
# Cleanup
    && apt-get remove -y git \
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s $(which python3) $(dirname $(which python3))/python \
    && ln -s "${VNC_DIRECTORY}/launch.sh" /usr/local/bin/launch-novnc

ADD vnc/ /etc/vnc
ADD x11/ /etc/x11
ADD bin/ /usr/local/bin
COPY vnc.conf /etc/vnc.conf

EXPOSE 6080

CMD [ "/bin/cat", "/etc/vnc/msg" ]
