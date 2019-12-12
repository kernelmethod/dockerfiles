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

# Reverse engineering
# Install Ghidra

ENV GHIDRA_DIR=/usr/share/ghidra
ARG GHIDRA_VERSION
ARG GHIDRA_SHA

RUN apt-get update \
    # Create directory to fix bug we would get otherwise
    # from installing default-jdk. Reference:
    #   https://github.com/debuerreotype/docker-debian-artifacts/issues/24
    && mkdir -p /usr/share/man/man1 \
    && apt-get install -y \
        --no-install-recommends \
        wget \
        unzip \
        ca-certificates \
        default-jdk \
    && mkdir -p ${GHIDRA_DIR} \
    && cd /tmp \
    && wget "https://ghidra-sre.org/ghidra_${GHIDRA_VERSION}.zip" \
        --progress=bar:force \
        -O /tmp/ghidra.zip \
    && echo "${GHIDRA_SHA}  /tmp/ghidra.zip" \
        | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && GHIDRA=$(find -maxdepth 1 -type d -iname "ghidra*" | head -n 1) \
    && mv ${GHIDRA}/* ${GHIDRA_DIR} \
#
# Cleanup
    && apt-get remove -y \
        wget \
        unzip \
        ca-certificates \
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf \
        ${GHIDRA_DIR}/docs \
        ${GHIDRA_DIR}/license \
        ${GHIDRA_DIR}/Extensions/Ghidra \
        ${GHIDRA_DIR}/Extensions/Eclipse \
        /tmp/ghidra* \
        /var/lib/apt/lists/* \
    && find ${GHIDRA_DIR} \
        -type f \
        -name "*src*.zip" \
        -print0 \
        | xargs -0 rm

RUN ln -s ${GHIDRA_DIR}/ghidraRun /usr/bin/ghidra
COPY ghidra/ghidra.png /usr/share/icons/
COPY ghidra/Ghidra.desktop /root/Desktop/

# Port 9999: autopsy
EXPOSE 9999

# VNC configuration
ARG VNC_PASS=password
RUN add-vnc-user -u root -p "${VNC_PASS}"

VOLUME /persistent
COPY run.sh /run.sh

ENV SCREEN_DIMS="1200x800"
CMD [ "/run.sh" ]
