FROM debian:buster-slim
ENV DEBIAN_FRONTEND noninteractive

# Include dist
ADD dist/ /root/dist/

# Install dependencies and packages
ARG DIONAEA_VERSION
RUN apt-get update -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y \
        --no-install-recommends \
	    build-essential \
	    ca-certificates \
	    check \
	    cmake \
	    cython3 \
        libcap2-bin \
	    libcurl4-openssl-dev \
	    libemu-dev \
	    libev-dev \
	    libglib2.0-dev \
	    libloudmouth1-dev \
	    libnetfilter-queue-dev \
	    libnl-3-dev \
	    libpcap-dev \
	    libpython3.7 \
	    libssl-dev \
	    libtool \
	    libudns-dev \
	    procps \
	    python3 \
	    python3-dev \
	    python3-bson \
	    python3-yaml \
	    fonts-liberation \
	    wget \
# Get and install dionaea
    && wget \
        --progress=bar:force \
        -O /root/dionaea.tar.gz \
        https://github.com/DinoTools/dionaea/archive/${DIONAEA_VERSION}.tar.gz \
    && tar xzf /root/dionaea.tar.gz -C /root \
    && mv /root/dionaea-${DIONAEA_VERSION} /root/dionaea \
    && cd /root/dionaea \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/dionaea .. \
    && make \
    && make install \
# Supply configs and set permissions
    && rm -rf /opt/dionaea/etc/dionaea/* \
    && mv /root/dist/etc/* /opt/dionaea/etc/dionaea/ \
# Setup runtime and clean up
    && apt-get purge -y \
      build-essential \
      ca-certificates \
      check \
      cmake \
      cython3 \
      libcurl4-openssl-dev \
      libemu-dev \
      libev-dev \
      libglib2.0-dev \
      libloudmouth1-dev \
      libnetfilter-queue-dev \
      libnl-3-dev \
      libpcap-dev \
      libssl-dev \
      libtool \
      libudns-dev \
      python3 \
      python3-dev \   
      python3-bson \
      python3-yaml \
      wget \
    && apt-get install -y \
      ca-certificates \
      python3 \
      python3-bson \
      python3-yaml \
      libcurl4 \
      libemu2 \
      libev4 \
      libglib2.0-0 \
      libnetfilter-queue1 \
      libnl-3-200 \
      libpcap0.8 \
      libpython3.5 \
      libudns0 \
    && apt-get autoremove --purge -y \
    && apt-get clean \
    && rm -rf \
        /root/* \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

RUN addgroup \
        --gid 2000 \
        dionaea \
    && adduser \
        --system \
        --no-create-home \
        --shell /bin/bash \
        --uid 2000 \
        --disabled-password \
        --disabled-login \
        --gid 2000 \
        dionaea \
# Allow unprivileged users to run services on privileged ports
    && setcap \
        "cap_net_bind_service=+ep" \
        /opt/dionaea/bin/dionaea

# Write all interesting data to a persistent volume, by creating symlinks from
# /opt/dionaea/var to the volume. This allows us to use a read-only filesystem
# while still preserving the information we want.
ENV PERSISTENT="/persistent"
RUN mv /opt/dionaea/var ${PERSISTENT} \
    && ln -s ${PERSISTENT} /opt/dionaea/var \
    && mkdir ${PERSISTENT}/dionaea \
    && mkdir ${PERSISTENT}/dionaea/roots \
    && mkdir ${PERSISTENT}/dionaea/roots/www \
    && mkdir ${PERSISTENT}/dionaea/roots/ftp \
    && mkdir ${PERSISTENT}/dionaea/roots/tftp \
    && mkdir ${PERSISTENT}/dionaea/roots/upnp \
    && mkdir ${PERSISTENT}/dionaea/bistreams \
    && mkdir ${PERSISTENT}/dionaea/binaries \
    && mkdir ${PERSISTENT}/dionaea/rtp \
    && chmod -R 750 /persistent \
    && chown -R dionaea:dionaea /persistent

VOLUME $PERSISTENT

# Start dionaea
#USER dionaea:dionaea
#CMD ["/opt/dionaea/bin/dionaea", "-u", "dionaea", "-g", "dionaea", "-c", "/opt/dionaea/etc/dionaea/dionaea.cfg"]
CMD ["/opt/dionaea/bin/dionaea", "dionaea", "-c", "/opt/dionaea/etc/dionaea/dionaea.cfg"]
