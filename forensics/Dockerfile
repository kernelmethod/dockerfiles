ARG FROM_IMAGE
FROM ${FROM_IMAGE}

###
### Install packages for forensic analysis
###

# General packages
RUN apt-get update \
    && apt-get install -y \
        python3 \
        python3-pip \
        zip \
        less \
        git \
    && ln -s $(which python3) $(dirname $(which python3))/python

# Memory analysis
RUN apt-get install -y \
        volatility \
        volatility-tools \
        xdot

# File analysis, data carving
RUN \
    # Install binwalk
    git clone --depth 1 \
        https://github.com/ReFirmLabs/binwalk.git \
        /usr/share/binwalk \
    && cd /usr/share/binwalk \
    && python3 setup.py install \
    # Install sleuthkit with autopsy frontend
    && apt-get install -y \
        sleuthkit \
        autopsy

# Port 9999: autopsy
EXPOSE 9999

# VNC configuration
ARG VNC_PASS=password
RUN mkdir ${HOME}/.vnc \
    && bash -c "vncpasswd -f <<< '${VNC_PASS}' > ${HOME}/.vnc/passwd" \
    && openssl req \
        -x509 \
        -newkey rsa:4096 \
        -keyout ${HOME}/.vnc/vnc.key \
        -out ${HOME}/.vnc/vnc.cert \
        -days 365 \
        -subj '/CN=forensics' \
        -nodes

VOLUME /persistent
COPY run.sh /run.sh

ENV SCREEN_DIMS="1200x800"
CMD [ "/run.sh" ]
