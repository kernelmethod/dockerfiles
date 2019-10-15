FROM wshand/xfce-vnc:ubuntu

RUN apt-get update \
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
        --groups ${VNC_GROUP} \
        ${GHIDRA_USER} \
    && mkdir ${GHIDRA_DIR} \
    && chown -R ${GHIDRA_USER}:${GHIDRA_USER} ${GHIDRA_DIR}

# Install Ghidra
ARG GHIDRA_VERSION=9.0.4_PUBLIC_20190516
ARG GHIDRA_SHA=a50d0cd475d9377332811eeae66e94bdc9e7d88e58477c527e9c6b78caec18bf

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
COPY ghidra.png ${GHIDRA_DIR}/ghidra.png

# Add Ghidra to PATH, and add entrypoint
USER root
COPY run.sh /run.sh
RUN ln -s ${GHIDRA_DIR}/ghidraRun /usr/bin/ghidra \
    && chown ${GHIDRA_USER}:${GHIDRA_USER} /run.sh \
    && chmod 500 /run.sh

# Add desktop application for Ghidra
RUN mkdir ${HOME}/Desktop
COPY Ghidra.desktop /home/${GHIDRA_USER}/Desktop/Ghidra.desktop
RUN chmod 700 /home/${GHIDRA_USER}/Desktop/Ghidra.desktop \
    && echo "Icon=${GHIDRA_DIR}/ghidra.png" \
        >> /home/${GHIDRA_USER}/Desktop/Ghidra.desktop \
    && chown -R ${GHIDRA_USER}:${GHIDRA_USER} /home/${GHIDRA_USER}

# Add VNC configuration for GHIDRA_USER
USER ${GHIDRA_USER}
ARG VNC_PASS="password"
RUN mkdir ${HOME}/.vnc \
    && openssl req \
        -x509 \
        -newkey rsa:4096 \
        -keyout ${HOME}/.vnc/vnc.key \
        -out ${HOME}/.vnc/vnc.cert \
        -days 365 \
        -subj '/CN=ghidra' \
        -nodes \
    && bash -c "vncpasswd -f <<< '${VNC_PASS}' > ${HOME}/.vnc/passwd" \
    && chmod 700 ${HOME}/.vnc \
    && chmod 400 ${HOME}/.vnc/*

WORKDIR /home/${GHIDRA_USER}
EXPOSE 13100 13101 13102

VOLUME /projects
CMD [ "/run.sh" ]
