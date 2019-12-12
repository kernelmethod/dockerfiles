ARG FROM_IMAGE
FROM "${FROM_IMAGE}"

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
    && GHIDRA=$(find /tmp -maxdepth 1 -type d -iname "ghidra*" | head -n 1) \
    && mv ${GHIDRA}/* ${GHIDRA_DIR} \
#
# Cleanup
    && apt-get remove -y \
        wget \
        unzip \
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
        -exec rm {} \;

COPY ghidra/server.conf ${GHIDRA_DIR}/server/server.conf

# Add Ghidra to PATH, and add entrypoint
RUN ln -s ${GHIDRA_DIR}/ghidraRun /usr/bin/ghidra

# Add a user for RE
ENV GHIDRA_USER=ghidra
ENV GHIDRA_USER_HOME=/home/${GHIDRA_USER}
RUN useradd \
        --shell /bin/bash \
        --create-home \
        --home-dir /home/${GHIDRA_USER} \
        ${GHIDRA_USER}


# Add desktop icon for Ghidra
RUN mkdir -p /home/${GHIDRA_USER}/Desktop
COPY ghidra/Ghidra.desktop /home/${GHIDRA_USER}/Desktop/Ghidra.desktop
COPY ghidra/ghidra.png ${GHIDRA_DIR}/ghidra.png
RUN chmod 700 /home/${GHIDRA_USER}/Desktop/Ghidra.desktop \
    && echo "Icon=${GHIDRA_DIR}/ghidra.png" \
    >> /home/${GHIDRA_USER}/Desktop/Ghidra.desktop \
    && chown -R ${GHIDRA_USER}:${GHIDRA_USER} /home/${GHIDRA_USER}

#COPY ghidra/ghidra.png /usr/share/icewm/icons
#ADD icewm-config/ /usr/share/icewm/

USER ${GHIDRA_USER}

# Add VNC configuration for GHIDRA_USER
ARG VNC_PASS="ghidra"
RUN add-vnc-user -u ${GHIDRA_USER} -p ${VNC_PASS}

WORKDIR /home/${GHIDRA_USER}
COPY run.sh .
#EXPOSE 13100 13101 13102

VOLUME /projects
CMD [ "./run.sh" ]
