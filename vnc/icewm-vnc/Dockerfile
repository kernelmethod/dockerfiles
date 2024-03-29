ARG FROM_IMAGE
FROM "${FROM_IMAGE}"

ARG RELEASE
ARG SHASUM

# Download the newest release of IceWM and install it
RUN apt-get update \
    && apt-get install -y \
        wget \
        lzip \
        # IceWM dependencies
        # Required for operation
        asciidoctor \
        gettext \
        xdg-utils \
        xfce4-terminal \
        # Required for compiling
        autoconf \
        autopoint \
        build-essential \
        cmake \
        git \
        libfontconfig1-dev \
        libfribidi-dev \
        libgdk-pixbuf2.0-dev \
        libtool \
        libsm-dev \
        libx11-dev \
        libxext-dev \
        libxft-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxrender-dev \
        libxcomposite-dev \
        libxdamage-dev \
        libxfixes-dev \
        libpng-dev \
        libjpeg-dev \
        libxpm-dev \
        librsvg2-dev \
    && apt-get install -y \
        --no-install-recommends \
        xfe \
    && wget \
        https://github.com/ice-wm/icewm/releases/download/${RELEASE}/icewm-${RELEASE}.tar.lz \
        -O /tmp/icewm.tar.lz \
        --progress=bar:force \
    && echo "${SHASUM}  /tmp/icewm.tar.lz" \
        | shasum -c - \
    && cd /tmp \
    && tar xf icewm.tar.lz \
    ###
    ### Configure and compile IceWM
    ###
    && cd /tmp/icewm-${RELEASE} \
    && ./configure \
    && make \
    && make install \
    ###
    ### Cleanup
    ###
    && apt-get remove -y \
        wget \
        lzip \
        autoconf \
        autopoint \
        build-essential \
        cmake \
        git \
        libfontconfig1-dev \
        libgdk-pixbuf2.0-dev \
        libtool \
        libsm-dev \
        libx11-dev \
        libxext-dev \
        libxft-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxrender-dev \
        libxcomposite-dev \
        libxdamage-dev \
        libxfixes-dev \
        libpng-dev \
        libjpeg-dev \
        libxpm-dev \
        librsvg2-dev \
    && rm -rf /tmp/icewm-${RELEASE} \
    && rm /tmp/icewm.tar.lz \
    && apt-get purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y

ADD vnc-config/ /etc/vnc/
ADD icewm-config/ /usr/share/icewm/
CMD cat /etc/vnc/msg
