FROM wshand/icewm-vnc:debian

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
    && apt-get clean

# Create non-root user to run Ghidra
ARG GHIDRA_USER="ghidra"
ENV GHIDRA_DIR /usr/share/ghidra

RUN useradd \
        --home-dir /home/${GHIDRA_USER} \
        --create-home \
        --shell /bin/bash \
        --password "0" \
        ${GHIDRA_USER} \
    && mkdir ${GHIDRA_DIR} \
    && chown -R ${GHIDRA_USER}:${GHIDRA_USER} ${GHIDRA_DIR}

# Install Ghidra
ARG GHIDRA_VERSION
ARG GHIDRA_SHA

USER ${GHIDRA_USER}
RUN cd /tmp && \
    wget "https://ghidra-sre.org/ghidra_${GHIDRA_VERSION}.zip" \
        --progress=bar:force \
        -O /tmp/ghidra.zip \
    && echo "${GHIDRA_SHA}  /tmp/ghidra.zip" \
        | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_$(echo $GHIDRA_VERSION | cut -d '_' -f1)/* ${GHIDRA_DIR} \
    && rm -rf \
        ${GHIDRA_DIR}/docs \
        ${GHIDRA_DIR}/license \
        ${GHIDRA_DIR}/Extensions/Ghidra \
        ${GHIDRA_DIR}/Extensions/Eclipse \
        /tmp/ghidra* \
    && find ${GHIDRA_DIR} \
        -type f \
        -name "*src*.zip" \
        -print0 \
        | xargs -0 rm

COPY server.conf ${GHIDRA_DIR}/server/server.conf

# Add Ghidra to PATH, and add entrypoint
USER root
COPY run.sh /run.sh
RUN ln -s ${GHIDRA_DIR}/ghidraRun /usr/bin/ghidra \
    && chown ${GHIDRA_USER}:${GHIDRA_USER} /run.sh \
    && chmod 500 /run.sh

# Add desktop application for Ghidra
#RUN mkdir ${HOME}/Desktop
#COPY ghidra/Ghidra.desktop /home/${GHIDRA_USER}/Desktop/Ghidra.desktop
#RUN chmod 700 /home/${GHIDRA_USER}/Desktop/Ghidra.desktop \
#    && echo "Icon=${GHIDRA_DIR}/ghidra.png" \
#        >> /home/${GHIDRA_USER}/Desktop/Ghidra.desktop \
#    && chown -R ${GHIDRA_USER}:${GHIDRA_USER} /home/${GHIDRA_USER}

COPY ghidra/ghidra.png /usr/share/icewm/icons
ADD icewm-config/ /usr/share/icewm/

# Add VNC configuration for GHIDRA_USER
ARG VNC_PASS="password"
RUN add-vnc-user ${GHIDRA_USER} ${VNC_PASS} \
    && add-vnc-user root ${VNC_PASS}

#USER ${GHIDRA_USER}
WORKDIR /home/${GHIDRA_USER}
EXPOSE 13100 13101 13102

VOLUME /projects
CMD [ "/run.sh" ]
