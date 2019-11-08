FROM debian:buster-slim

# Install the most recent version of Julia
ARG JULIA_VERSION=1.3.0-rc4
ARG JULIA_BINARIES="https://julialang-s3.julialang.org/bin"
ENV JULIA_PATH=/usr/local/julia
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        wget \
# Download Julia and verify the download
    && MAJOR_VERSION="$(echo ${JULIA_VERSION} | cut -d . -f1-2)" \
    && wget \
        --progress=bar:force \
        "${JULIA_BINARIES}/checksums/julia-${JULIA_VERSION}.sha256" \
        -O "/tmp/julia-${JULIA_VERSION}.sha256" \
    && wget \
        --progress=bar:force \
        "${JULIA_BINARIES}/linux/x64/${MAJOR_VERSION}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" \
        -O "/tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" \
    && cd /tmp \
    && grep \
        "julia-${JULIA_VERSION}-linux-x86_64.tar.gz" \
        "julia-${JULIA_VERSION}.sha256" \
        > checksums.txt \
    && sha256sum -c checksums.txt \
# Decompress and move files to /usr/local/julia
    && tar xf "julia-${JULIA_VERSION}-linux-x86_64.tar.gz" \
    && mv "julia-${JULIA_VERSION}" ${JULIA_PATH} \
    && chown -R root:root ${JULIA_PATH} \
    && ln -s ${JULIA_PATH}/bin/julia /usr/bin/julia \
# Cleanup
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

### Configure Julia
COPY config.jl /tmp/config.jl
RUN julia /tmp/config.jl \
    && rm /tmp/config.jl

### Add a non-root user to run Julia
ENV JULIA_USER=julia \
    JULIA_HOME=/home/julia
RUN useradd \
        --create-home \
        --shell /bin/bash \
        ${JULIA_USER}

USER ${JULIA_USER}
WORKDIR /home/${JULIA_USER}
RUN mkdir .julia work
ADD config/ .julia/

ENV TERM="xterm-256color" \
    USER=${JULIA_USER} \
    PATH=${JULIA_PATH}/bin:${PATH}

CMD [ "julia" ]
