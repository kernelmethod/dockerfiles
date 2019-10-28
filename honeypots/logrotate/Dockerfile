FROM alpine:3.10

RUN apk add -U logrotate \
    && rm -rf /var/cache/apk/*

ENV ADBHONEY=/opt/adbhoney
ENV COWRIE=/opt/cowrie
ENV DIONAEA=/opt/dionaea

ADD conf/ /etc/logrotate.d
ADD cron.daily/ /etc/periodic/daily

VOLUME ${ADBHONEY}
VOLUME ${COWRIE}
VOLUME ${DIONAEA}

CMD [ "/usr/sbin/crond", "-f", "-l", "4" ]
