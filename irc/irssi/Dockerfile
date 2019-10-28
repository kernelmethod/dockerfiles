# Irssi IRC client
# https://irssi.org/
#
FROM alpine:3.10

RUN apk add -U irssi

ARG USERNAME=irssi
ARG NICKNAME=irssi

RUN adduser -D -s /bin/false -h /home/${USERNAME} ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}
CMD [ "irssi" ]
