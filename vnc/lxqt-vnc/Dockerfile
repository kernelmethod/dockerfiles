ARG FROM_IMAGE
FROM "${FROM_IMAGE}"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y \
            lxqt-core \
            dbus-x11 \
            xfwm4 \
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TERM=xterm-256color

COPY xstartup /etc/vnc
COPY session.conf /etc/xdg/lxqt/session.conf
