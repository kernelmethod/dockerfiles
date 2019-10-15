# Run Brave browser from a container
FROM wshand/xfce-vnc:ubuntu

RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        curl \
        gnupg \
    && curl https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
      -s \
      -o /tmp/brave-core.asc \
    && apt-key \
      --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg \
      add /tmp/brave-core.asc \
    && . /etc/os-release \
    && echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" \
        | tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list \
    && apt-get update \
    && apt-get install -y brave-browser \
    # Clean up
    && apt-get clean \
    && rm /tmp/brave-core.asc

# Create a non-root user to run the browser
ENV BRAVE_USER brave
ENV BRAVE_HOME /home/${BRAVE_USER}
RUN useradd \
        --no-create-home \
        --shell /bin/bash \
        --password "0" \
        --home-dir ${BRAVE_HOME} \
        --group ${VNC_GROUP} \
        ${BRAVE_USER} \
    && mkdir ${BRAVE_HOME} \
    && chown -R ${BRAVE_USER} ${BRAVE_HOME}

COPY run.sh /run.sh
RUN chmod 500 /run.sh \
    && chown ${BRAVE_USER}:${BRAVE_USER} /run.sh

WORKDIR ${BRAVE_HOME}
USER ${BRAVE_USER}

# Configure VNC
ARG VNC_PASS="password"
RUN mkdir ${HOME}/.vnc \
    && openssl req \
        -x509 \
        -newkey rsa:4096 \
        -keyout ${BRAVE_HOME}/.vnc/vnc.key \
        -out ${BRAVE_HOME}/.vnc/vnc.cert \
        -days 365 \
        -subj '/CN=brave' \
        -nodes \
    && bash -c "vncpasswd -f <<< '${VNC_PASS}' > ${HOME}/.vnc/passwd" \
    && chmod 700 ${BRAVE_HOME}/.vnc \
    && chmod 400 ${BRAVE_HOME}/.vnc/*

CMD /run.sh
