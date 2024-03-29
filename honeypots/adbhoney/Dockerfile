FROM alpine 
#
# Include dist
ADD dist/ /root/dist/
#
# Install packages
RUN apk -U --no-cache add \
        git \
        libcap \
        python2 \
        python2-dev \
# Install adbhoney from git
    && git clone \
        --depth=1 \
        https://github.com/huuck/ADBHoney \
        /opt/adbhoney \
    && cp \
        /root/dist/adbhoney.cfg \
        /opt/adbhoney \
    && sed \
        -i 's/dst_ip/dest_ip/' \
        /opt/adbhoney/adbhoney/core.py \
    && sed \
        -i 's/dst_port/dest_port/' \
        /opt/adbhoney/adbhoney/core.py \
# Setup user, groups and configs
    && addgroup -g 2000 adbhoney \
    && adduser -S -H -s /bin/ash -u 2000 -D -g 2000 adbhoney \
    && chown -R adbhoney:adbhoney /opt/adbhoney \
    && setcap cap_net_bind_service=+ep $(which python2.7) \
# Clean up
    && apk del --purge \
        git \
        python2-dev \
    && rm -rf /root/* \
    && rm -rf /var/cache/apk/*

# Move the contents of /opt/adbhoney/dl and /opt/adbhoney/log to
# the /persistent volume. Create symlinks from /opt/adbhoney to
# the volume so that writes to those directories amount to writes
# to the volume.
RUN mkdir /persistent \
    && mkdir -p /opt/adbhoney/dl \
    && mkdir -p /opt/adbhoney/log \
    && mv /opt/adbhoney/dl /persistent \
    && mv /opt/adbhoney/log /persistent \
    && ln -s /persistent/dl /opt/adbhoney/dl \
    && ln -s /persistent/log /opt/adbhoney/log \
    && chmod -R 750 /persistent \
    && chown -R adbhoney:adbhoney /persistent

VOLUME /persistent

# Set workdir and start adbhoney
STOPSIGNAL SIGINT
USER adbhoney:adbhoney
WORKDIR /opt/adbhoney/
CMD nohup /usr/bin/python run.py
