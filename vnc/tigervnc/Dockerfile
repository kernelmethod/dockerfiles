ARG FROM_IMAGE
FROM "${FROM_IMAGE}"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y \
            tigervnc-standalone-server \
            tigervnc-xorg-extension \
            openssl \
            sudo \
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add convenience scripts, and a message to display when the container is run
RUN mkdir /etc/vnc
COPY add-vnc-user.sh /etc/vnc/
COPY msg /etc/vnc/
RUN chmod -R a-w /etc/vnc/ \
    && ln -s /etc/vnc/add-vnc-user.sh /usr/bin/add-vnc-user

# Expose VNC ports
EXPOSE 5900-6000

CMD cat /etc/vnc/msg
