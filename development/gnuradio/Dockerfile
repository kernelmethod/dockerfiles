FROM wshand/xfce-vnc:debian

RUN apt-get update \
    && apt-get install -y gnuradio \
    && add-vnc-user root "password" \
    # Cleanup
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY run.sh /root
CMD [ "/root/run.sh" ]
