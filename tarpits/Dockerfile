FROM alpine:3.10

RUN apk update \
    && apk upgrade \
    && apk add --no-cache python3

# Add Python dependencies
RUN python3 -m pip install --no-cache-dir pyyaml

# Add non-root user to run the tarpits
ARG TARPIT_USER=kmtd
RUN adduser -D -s /bin/false ${TARPIT_USER}
ADD tarpits/ /home/${TARPIT_USER}

EXPOSE 2222 8080
WORKDIR /home/${TARPIT_USER}

CMD [ "./run.sh" ]
