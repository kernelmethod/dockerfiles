ARG FROM_IMAGE
FROM ${FROM_IMAGE}

###
### Install packages for forensic analysis
###

# General packages
RUN apt-get update \
    && apt-get install -y \
        # General tools
        python3 \
        python3-pip \
        zip \
        less \
        git \
        vim

# Memory analysis
RUN apt-get install -y \
        volatility \
        volatility-tools \
        xdot

# File analysis, data carving
RUN git clone --depth 1 \
        https://github.com/ReFirmLabs/binwalk.git \
        /usr/share/binwalk \
    && cd /usr/share/binwalk \
    && python3 setup.py install \
    && apt-get install -y \
        sleuthkit \
        autopsy \
        xxd

RUN apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY Terminal.desktop /root/Desktop/Terminal.desktop

# Port 9999: autopsy
EXPOSE 9999

# VNC configuration
ARG VNC_PASS=password
RUN add-vnc-user -u root -p "${VNC_PASS}"

VOLUME /persistent
COPY run.sh /run.sh

ENV SCREEN_DIMS="1200x800"
CMD [ "/run.sh" ]
