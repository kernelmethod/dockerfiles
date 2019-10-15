FROM wshand/xfce-vnc:debian

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

# Add welcome message to the .bashrc 
COPY .bashrc /root

VOLUME /persistent
CMD [ "bash" ]
