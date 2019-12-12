ARG FROM_IMAGE
FROM ${FROM_IMAGE}

###
### Install packages for forensic analysis
###

# General packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        # General tools
        python3 \
        python3-pip \
        less \
        vim \
        # Memory analysis
        volatility \
        volatility-tools \
        xdot \
        # File analysis, data carving
        sleuthkit \
        autopsy \
        xxd \
#
# Cleanup
    && rm -rf /var/lib/apt/lists/*

COPY Terminal.desktop /root/Desktop/Terminal.desktop

# File analysis, data carving
RUN apt-get update \
    && apt-get install -y git \
    && git clone --depth 1 \
        https://github.com/ReFirmLabs/binwalk.git \
        /usr/share/binwalk \
    && cd /usr/share/binwalk \
    && python3 setup.py install \
    && apt-get remove -y git \
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

# Port 9999: autopsy
EXPOSE 9999

# VNC configuration
ARG VNC_PASS=password
RUN add-vnc-user -u root -p "${VNC_PASS}"

VOLUME /persistent
COPY run.sh /run.sh

ENV SCREEN_DIMS="1200x800"
CMD [ "/run.sh" ]
