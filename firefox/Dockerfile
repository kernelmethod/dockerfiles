FROM wshand/xfce-vnc:debian

RUN apt-get update \
    && apt-get install -y firefox-esr

COPY run.sh /run.sh

# Configure VNC
ARG VNC_PASS="password"
RUN mkdir ${HOME}/.vnc \
    && openssl req \
        -x509 \
        -newkey rsa:4096 \
        -keyout ${HOME}/.vnc/vnc.key \
        -out ${HOME}/.vnc/vnc.cert \
        -days 365 \
        -subj '/CN=' \
        -nodes \
    && bash -c "vncpasswd -f <<< '${VNC_PASS}' > ${HOME}/.vnc/passwd" \
    && chmod 700 ${HOME}/.vnc \
    && chmod 400 ${HOME}/.vnc/*

WORKDIR /root
CMD [ "/run.sh" ]
