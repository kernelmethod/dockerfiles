FROM rust:1.38-slim-buster

ENV RUST_USER=ferris
RUN apt-get update \
    && apt-get install -y vim \
# Create a non-root user to run the environment
    && useradd \
        --home-dir /home/${RUST_USER} \
        --create-home \
        --password "0" \
        --shell /bin/bash \
        ${RUST_USER} \
# Cleanup
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

# Define remaining environmental variables
USER ${RUST_USER}
WORKDIR /home/${RUST_USER}/
ENV TERM=xterm-256color \
    USER=${RUST_USER}
CMD [ "/bin/bash" ]
