FROM wshand/xfce-vnc:debian

ARG CUTTER_ENABLE_PYTHON=OFF
ARG CUTTER_ENABLE_PYTHON_BINDINGS=OFF
ARG CUTTER_ENABLE_KSYNTAXHIGHLIGHTING=OFF
ARG CUTTER_ENABLE_GRAPHVIZ=OFF
ARG CUTTER_ENABLE_CRASH_REPORTS=OFF

# Install dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        libzip4 \
        libqt5svg5 \
        qt5-default \
        zlib1g \
    && ( [ "$CUTTER_ENABLE_PYTHON" = "OFF" ] || \
        apt-get install -y \
            python3 \
            python3-dev \
            shiboken2 ) \
    && rm -rf /var/lib/apt/lists/*

ARG CUTTER_VERSION

# Download Cutter source and install
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        git \
        build-essential \
        curl \
        cmake \
        libzip-dev \
        libqt5svg5-dev \
        meson \
        pkg-config \
        zlib1g-dev \
    && ( [ "$CUTTER_ENABLE_PYTHON" = "OFF" ] || \
        apt-get install -y libshiboken2-dev ) \
    && git clone \
        --depth 1 \
        --recurse-submodules \
        --single-branch \
        -b "${CUTTER_VERSION}" \
        https://github.com/radareorg/cutter \
        /usr/share/cutter \
    && cd /usr/share/cutter/src \
    && mkdir build \
    && cmake -B build \
        -DCUTTER_USE_BUNDLED_RADARE2=ON \
        -DCUTTER_ENABLE_PYTHON=${CUTTER_ENABLE_PYTHON} \
        -DCUTTER_ENABLE_PYTHON_BINDINGS=${CUTTER_ENABLE_PYTHON_BINDINGS} \
        -DCUTTER_ENABLE_KSYNTAXHIGHLIGHTING=${CUTTER_ENABLE_KSYNTAXHIGHLIGHTING} \
        -DCUTTER_ENABLE_GRAPHVIZ=${CUTTER_ENABLE_GRAPHVIZ} \
        -DCUTTER_ENABLE_CRASH_REPORTS=${CUTTER_ENABLE_CRASH_REPORTS} \
    && cmake --build build \
#
# Cleanup
    && apt-get remove -y \
        git \
        build-essential \
        curl \
        cmake \
        libzip-dev \
        libqt5svg5-dev \
        meson \
        pkg-config \
        zlib1g-dev \
    && ( [ "$CUTTER_ENABLE_PYTHON" = "OFF" ] || \
        apt-get remove -y libshiboken2-dev ) \
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf \
        /var/lib/apt/lists/*

# Create a user to run Cutter
ENV CUTTER_USER=r2
RUN useradd \
        --shell /bin/bash \
        --create-home \
        --home-dir /home/${CUTTER_USER} \
        ${CUTTER_USER} \
    && mkdir -p /home/${CUTTER_USER}/Desktop

# Add desktop icon for Cutter
COPY Cutter/Cutter.desktop /home/${CUTTER_USER}/Desktop
COPY Cutter/cutter.svg /usr/share/icons/
RUN chown -R \
        ${CUTTER_USER}:${CUTTER_USER} \
        /home/${CUTTER_USER}

# Create symlinks to the binaries we compiled
RUN ln -s \
        /usr/share/cutter/src/build/Cutter \
        /usr/local/bin/Cutter

USER ${CUTTER_USER}
WORKDIR /home/${CUTTER_USER}

COPY run.sh /run.sh
CMD [ "sh", "/run.sh" ]
