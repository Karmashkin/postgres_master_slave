FROM postgres:9.4-alpine
MAINTAINER Karmashkin <vlad@zolotous.com>

# python3 and yacron
RUN set -ex \
    && apk add --no-cache bash python3 py3-pip \
    && apk add --no-cache --virtual .py3-deps \
         musl-dev \
         python3-dev \
         gcc \
         make \
    && pip3 install yacron==0.7.0b1 \
    && apk del .py3-deps

RUN apk add --no-cache \
    tzdata \
    msmtp \
    postgresql-client \
    coreutils \
    tar \
    && ln -sf /usr/bin/msmtp /usr/sbin/sendmail \
    && printf "host postfix\n" > /etc/msmtprc

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["yacron", "-c", "/tmp/crontab.yaml"]

