FROM wshand/xfce-vnc:debian

ARG CUTTER_VERSION

# Download Cutter and unpack image
RUN apt-get update \
    && apt-get install -y wget \
    && cd /tmp \
    && CUTTER_DOWNLOADS=https://github.com/radareorg/cutter/releases/download \
    && APPIMAGE="Cutter-${CUTTER_VERSION}-x64.Linux.Appimage" \
    && cd /tmp \
    && wget \
        --progress=bar:force \
        "${CUTTER_DOWNLOADS}/${CUTTER_VERSION}/${APPIMAGE}" \
    && chmod +x "${APPIMAGE}" \
    && ./"${APPIMAGE}" --appimage-extract \
    && mv squashfs-root /usr/share/Cutter \
    && find /usr/share/Cutter -type d -exec chmod g+rx,o+rx {} \; \
#
# Cleanup
    && apt-get remove -y wget \
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf /tmp/* /var/lib/apt/lists/*

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
RUN chown -R \
        ${CUTTER_USER}:${CUTTER_USER} \
        /home/${CUTTER_USER}

# Create symlinks to the binaries we compiled
RUN ln -s \
        /usr/share/Cutter/AppRun \
        /usr/local/bin/Cutter

USER ${CUTTER_USER}
WORKDIR /home/${CUTTER_USER}

COPY run.sh /run.sh
CMD [ "sh", "/run.sh" ]
